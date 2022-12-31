#!/usr/bin/perl
# #!/home/utils/perl-5.8.8/bin/perl
use warnings;
use strict;
use Data::Dumper;
use File::Basename qw(basename dirname);
use File::Find;
use File::Temp qw(tempdir);
use Getopt::Long;
use POSIX qw( strftime );
sub say { print @_, "\n" }
$Data::Dumper::Indent   = 1;
$Data::Dumper::Sortkeys = 1;

my $scriptName = 'callGraph';

sub usage {
    my $usage = "\n
'$scriptName' by Chris Koknat  https://github.com/koknat/callGraph
Purpose:
    $scriptName is a multi-language tool to statically parse source code for function definitions and calls.
    It generates a call graph image and displays it on screen.
    The parser was designed for Perl/Python/TCL, and has been extended for other languages, such as
    awk, bash, basic, dart, fortran, go, javascript, julia, lua, kotlin, matlab, pascal, php, R, raku, 
      ruby, rust, scala, swift, and typescript.
    C/C++/Java are not supported, since their complicated syntax requires heavy machinery.
Usage:
    $scriptName  <files>  <options>
    If the script calls helper modules, and want the call graph to display the modules' functions,
        list the modules explicitly on the command line:
    $scriptName script.pl path/moduleA.pm path/moduleB.pm
    
Options:
    -language <lang>           By default, filename extensions are parsed for .pl .pm .tcl .py, etc.
                               If those are not found, the first line of the script (#! shebang) is inspected.
                               If neither of those give clues, use this option to specify 'pl', 'tcl', 'py', etc
							   This option is required if a directory is scanned
    -start <function>          Specify function(s) as starting point instead of the main code.
                               These are displayed in green.
                               This is useful when parsing a large script, as the generated graph can be huge.
                               In addition, the calls leading to this function are charted.
                               Functions which are not reachable from one of the starting points
                                 are not charted.
                               -start __MAIN__  can be very useful when multiple source files
                                 are specified on the command line
                               The filename can be included as well:
                                -start <file>:<function>
    -ignore <regex>            Specify function(s) to ignore.
                               This is useful when pruning the output of a large graph.
                               In particular, use it to remove logging or other helper functions which are
                                 called by many functions, and only clutter up the graph.
                               To ignore multiple functions, use this regex format:
                                   -ignore '(abc|xyz)'
    -output <filename>         Specify an output filename
                               By default, the .png file is named according to the first filename.
                               If a filename ending in .dot is given,
                                 only the intermediate .dot file is created.
                               If a filename ending in .svg is given, svg format is used
                               If a filename ending in .pdf is given, pdf format is used
    -noShow                    By default, the .png file is displayed.  This option prevents that behavior.
    -fullPath                  By default, the script strips off the path name of the input file(s).
                               This option prevents that behavior.
    -writeSubsetCode <file>    Create an output source code file which includes only the functions
                                 included in the graph.
                               This can be useful when trying to comprehend a large legacy code.
    -ymlOut <file>             Create an output YAML file which describes the following for each function:
                                   * which functions call it
                                   * which functions it calls
                               This can be useful to create your own automation or custom formatting
							   
	-ymlIn <file>              Parse a YAML file instead of parsing source files
                               The format is the same as the one created by -ymlOut
    -verbose                   Provides 2 additional functionalities:
                               
                               1) Displays the external scripts referenced within each function
                               2) For Perl/TCL, attempts to list the global variables
                                    used in each function call in the graph.
                                  Global variables are arguably not the best design paradigm,
                                    but they are found extensively in real-world legacy scripts.
                                  Perl:
                                      'my' variables will affect this determination (use strict).
                                      Does not distinguish between \$var, \@var and \%var.
                                  TCL:
                                      Variables declared as 'global' but not used, are marked with a '*'
Usage examples:
    $scriptName  example.py
    $scriptName  example.pl example_helper_lib.pm
    $scriptName  <directory> -language 'go'
Algorithm:
    $scriptName uses a simple line-by-line algorithm, using regexes to find function definitions and calls.
    Function definitions can be detected easily, since they start with identifiers such as:
        'sub', 'def', 'proc', 'function', 'func', 'fun', or 'fn'
    Function definitions end with '}' or 'end' at the same nesting level as the definition.
    Function calls are a bit more tricky, since built-in function calls look exactly like user function calls.
        To solve this, the algorithm first assumes that anything matching 'word(...)' is a function call,
        and then discards any calls which do not have corresponding definitions.
    For example, Perl:
        sub funcA {
            ...
            if (\$x) {
                print(\$y);
                funcB(\$y);
            }
            ...
        }
        sub funcB {
            ...
        }
    Since this is not a true parser, the formatting must be consistent so that nesting can be determined.
    If your script does not follow this rule, consider running it through a linter first.
    Also, don't expect miracles such as parsing dynamic function calls.
    Caveats aside, it seems to work well on garden-variety scripts spanning tens of thousands of lines,
        and has helped me unravel large pieces of legacy code to implement urgent bug fixes.
    ";
    $usage .= "
Acknowledgements:
    This code borrows core functionality from https://github.com/cobber/perl_call_graph
Requirements:
    GraphViz and the Perl GraphViz library must be installed:
        sudo apt install graphviz
        sudo apt install make
        sudo cpan install GraphViz
        \n" if !-d '/home/ckoknat';
    say "\n$usage\n";
    exit 0;
}

# Changes from original code:
#     automatically convert dot to png using system command 'dot -Tpng', and displays png to screen using 'eog' or similar
#     do not print the filename in the graph bubbles unless multiple files are given
#     support languages besides Perl
#     handles '\' line continuation characters
#     handle Perl '__END__' syntax
#     verbose mode creates report with all globals used in each function in the graph
#     option -writeSubsetCode <file> to create an output source file containing only the procs used in the graph
# Additional caveats:
#     it is assumed that function names are unique across files
# Notes:
#     For C/C++/Java, consider using Doxygen or kcachegrind or Intel Single Event API or Eclipse instead.
#     For Perl, if you need something more sophisticated, you can run the dynamic profiler NYTProf:
#         <path_to_perl>/bin/perl -d:NYTProf <script>
#         <path_to_perl>/bin/nytprofcg
#         kcachegrind nytprof.callgrind
#     Python and PHP can also use a similar toolchain
#     Dynamic generation will only include paths which are actually run, and may take much longer to run than static generation
#     If the resulting png size is too big, use ImageMagick:
#         convert foo.png -resize 1000 foo-small.png
# Goals:
#     Ease of use:  user runs one command to parse file, create png, display png
#     Works on any Linux system (including Apple), as long as GraphViz is installed
#     Monolithic code for ease of sharing

my %opt;
my $d;
Getopt::Long::GetOptions(
    \%opt,
    #'cluster!',
    'help|?',
    'output=s',
    'start=s',
    'ignore=s',
    'fullPath',
    'verbose',
    'language=s',
    'regression',
    'noShow',
    'obfuscate',
    'writeSubsetCode=s',
    'ymlIn=s',
    'ymlOut=s',
    'writeFunctions',
    'd' => sub { $d = 1 },
) or usage();
usage() if $opt{help} or ( !@ARGV and !defined $opt{ymlIn} );

# Debugger from CPAN: "sudo cpan" "install Debug::Statements"
sub D  { say "Debug::Statements has been disabled" }
sub d  { say "Debug::Statements has been disabled" if $d }
sub ls { }
#use lib "/home/ate/scripts/regression";
#use Debug::Statements ":all";    # d ''

d '%opt';
eval 'use GraphViz ()';
if ($@) {
    say "\n$@";
    say "ERROR:  Install GraphViz and the CPAN GraphViz module to create the call graph";
    say "        sudo apt install graphviz";
    say "        and";
    say "        sudo apt install make";
    say "        and";
    say "        sudo cpan install GraphViz";
    exit 1;
}
my ( @files, $tmpdir, $output );
if ( defined $opt{ymlIn} ) {
    if ( defined $opt{output} ) {
        $output = $opt{output};
    } else {
        ( $output = $opt{ymlIn} ) =~ s/\.ya?ml$//;
    }
} else {
    if ( -d $ARGV[0] ) {
        die "\nERROR:  Must specify -language <language>\n" if !defined $opt{language};
        my $language = $opt{language};
        $language = 'pl|.pm' if $language eq 'pl';
        for my $dir (@ARGV) {
            if ( -d $dir ) {
                find(
                    sub {
                        return if -d $File::Find::name;
                        return unless $File::Find::name =~ /(\.$language)$/;
                        push @files, $File::Find::name;
                    },
                    $dir
                );
                if ( !@files ) {
                    die "\nERROR:  Did not find any $language files in $dir/\n";
                }
            } else {
                push @files, $dir;
            }
        }
    } else {
        @files = @ARGV;
    }
    d '@files';
    for my $file (@ARGV) {
        die "\nERROR:  $file not found!\n" if !-r $file;
    }
    if ( defined $opt{output} ) {
        $output = $opt{output};
        if ( -f $output ) {
            die "\nERROR:  file $output is not writeable\n" if !-w $output;
        } else {
            die "\nERROR:  '$output' is not writeable\n" if !-w dirname($output);
        }
    } else {
        if ( -w '.' ) {
            #$output = './' . basename( $ARGV[0] );
            $tmpdir = tempdir( '/tmp/call_graph_XXXX', CLEANUP => 0 );
            $output = "$tmpdir/" . basename( $ARGV[0] );
        } else {
            $tmpdir = tempdir( '/tmp/call_graph_XXXX', CLEANUP => 0 );
            $output = "$tmpdir/" . basename( $ARGV[0] );
        }
    }
    if ( -d $output ) {
        # TODO test -output <directory>
        # If a directory name is given in -output (or no -output), create a name based on timestamp
        my $base_name = 'call_graph_';
        if ( $opt{start} ) {
            $base_name .= $opt{start};
            $base_name =~ s/\\.//g;
            $base_name =~ s/[^-\w]//g;
        } else {
            $base_name .= strftime( "%Y%m%d-%H%M%S", localtime() );
        }
        $output =~ s{/*$}{/$base_name};
    }
}
( my $dot = $output ) =~ s/\.(dot|png|svg|pdf)$//;
$dot .= '.dot';

my $call_graph;
if ( $opt{ymlIn} ) {
    eval 'use YAML::XS ()';
    if ($@) {
        say "\n$@\n";
        say "ERROR:  Install YAML::XS to use option -ymlIn";
        say "        sudo cpan install YAML::XS";
        exit 1;
    } else {
        say "Reading file $opt{ymlIn}";
        $call_graph = YAML::XS::LoadFile( $opt{ymlIn} );
        # Sanity check
        my ( $calls, $called_by );
        for my $sub ( keys %{$call_graph} ) {
            # $call_graph->{"$caller_file:$caller_sub"}{calls}{"$caller_file:$referenced_sub"}++;
            # $call_graph->{"$caller_file:$referenced_sub"}{called_by}{"$caller_file:$caller_sub"}++;
            for my $item ( keys %{ $call_graph->{$sub} } ) {
                $calls++     if $item eq 'calls';
                $called_by++ if $item eq 'called_by';
            }
        }
        d '$call_graph $calls $called_by';
        if ( !$calls ) {
            die "\nERROR:  input yml does not contain any 'calls' items!\n        The format should be similar to the one created by -ymlOut <file>\n";
        }
        if ( !$called_by ) {
            die "\nERROR:  input yml does not contain any 'called_by' items!\n        The format should be similar to the one created by -ymlOut <file>\n";
        }
    }
    goto INTERMEDIATE_FORMAT;
}

# Determine language
die "\nERROR:  No input files specified!\n" unless @ARGV;
my $language = defined $opt{language} ? $opt{language} : getScriptType( file => $files[0], scriptsOnly => 1 );
d '$language';
die "\nERROR:  language could not be determined.  Use option -language <language>\n" if !defined $language;
my $main = '__MAIN__';

sub defineSyntax {
    my $language = shift;
    # Define the regular expressions which detect function definitions & calls
    my $languageSyntax = {
        # http://rigaux.org/language-study/syntax-across-languages.html
        # To add support for another language, add to the functionDefinition dictionary, and add the extension to the regex in getScriptType
        # Note that sometimes functions span lines, such as:
        #     function foo (a,
        #         b, c,
        #         d)
        #     Since the parser uses a simple line-by-line algorithm, it's helpful to only require the first parenthesis
        functionDefinition => {
            awk  => '(\s*)(function)\s+(\w+)\s*\(',
            bas  => '(\s*)(?:public\s+)?(function|sub)\s+(\w+)\s*\(',
            dart => '(\s*)((?<=main)|void|bool|int|double|String|List|Map|Runes|Symbol)\s+(\w+)\s*\(',                                                                          # Because no type is required, encountering false positive for built-in functions like 'if(...){}', so requiring that 'void' is used for any function besides 'main'
            for  => '(\s*)(?:character\s+|complex\s+|elemental\s+|integer\s+|logical\s+|module\s+|pure\s+|real\s+|recursive\s+)*(function|program|subroutine)\s+(\w+)\s*\(',    # fortran .fypp is problematic because of preprocessor
            go   => '(\s*)(func)\s+(?:\(.*?\))?\s*(\w+)',                                                                                                                       # Non-greedy because of  func (f *Field) Alive(x, y int) bool {}
            jl   => '(\s*)(?:@inline\s+)?(function)\s+([\w\.\!\$]+)\s*[^\(]*\(',
            js   => '(\s*)(?:async\s+)?(function)\s+(\w+)\s*\(',
            kt   => '(\s*)(?:internal\s+|private\s+|protected\s+|public\s+)?(fun)\s+(\w+)\s*\(',
            lua  => '(\s*)(?:local\s+)?(function)\s+([\w\.]+)\s*\(',
            m    => '(\s*)(function)[^=]*=\s*(\w+)\s*\(',                                                                                                                       # matlab
            pas  => '(\s*)(function|procedure)\s+(\w+)\s*\(',
            php  => '(\s*)(?:abstract\s+|final\s+|private\s+|protected\s+|public\s+)?(?:static\s+)?(function)\s+(\w+)\s*\(',
            pl   => '(\s*)(sub)\s+(\w+)',
            py   => '(\s*)(def)\s+(\w+)\(',
            #r     => '(\s*)()(\w+)\s+<-\s+function\s*\(.*\)',  # original
            #r     => '(\s*)()(\w+)\s+(?:<-|=)\s+function\s*\(.*\)',
            #r     => '(\s*)()(\w+)\s+(?:<-|=)\s+function\s*\([^\)]*\)',
            #r     => '(\s*)()(\w+)\s+<-\s+function\s*\([^\)]*\)',
            #r     => '(\s*)()(\w+)\s+<-\s+function\s*\(',
            r     => '(\s*)()(\w+)\s+(?:<-|=)\s+function\s*\(',
            rb    => '(\s*)(def)\s+(\w+)',
            rs    => '(\s*)(?:pub\s+)?(fn)\s+(\w+)',
            sc    => '(\s*)(?:private\s+|protected\s+)?(def)\s+(\w+)',
            sh    => '(\s*)(function\b|)\s*(\w+)\(?\)?\s*{',
            swift => '(\s*)(?:fileprivate\s+|internal\s+|open\s+|public\s+)?(?:static\s+)?(func)\s+(\w+)',
            tcl   => '(\s*)(proc)\s+([\w:]+)',
            ts    => '(\s*)(function)\s+(\w+)\s*\(',
            # function bit [7:0] sum;
            # function byte mul (...);
            # task automatic display()
            # task sum
            v => '(\s*)(?:virtual\s+)?(function|task)\s+(?:[^(]+)?\s+(\w+)\s*(?:$|;|\()',
            # C, C++, and Java syntaxes are not well suited for regexes
            #
            # Since java function does not begin with 'function' or similar, require that the opening curly brace is on the same line
            #         spaces         public static                                                                         void                foo
            #java => '^()((?:(?:public|private|protected|static|final|native|synchronized|abstract|transient)+\s+)*(?:[$_\w<>\[\]\s]+))*?\s+(\S+)\s*\(.*\)\s*\{\s*$',
            java => '(\s*)(?=public|private|protected|static|final|native|synchronized|abstract|transient)([^(]+)\s+(\S+)\s*\(',
            # cpp regex will be somewhat similar to java, but a lot more complicated.  I'm not pursuing this
            # To create a cpp call graph:
            #     clang++ -S -emit-llvm main.cpp -o - | opt -analyze -dot-callgraph
            #     dot -Tpng -ocallgraph.png callgraph.dot
            #cpp  => '^(\s*)((?:(?:public|private|protected|static|final|native|synchronized|abstract|transient)+\s+)*(?:[$_\w<>\[\]\s]+))*?\s+(\S+)\s*\(.*\)\s*(\{)\s*$',
            cpp => '(\s*)(?=.*(?:void|bool|int|short|long|double|char|size_t|string|vector|unsigned|istream|ostream))([^(]+)\s+(\S+)\s*\(',
            # Attempting to support simple C syntax
            # int main(int argc, char *argv[])
            # int CTclParser::SplitList( int *line, char *list, int *argcPtr, char ***argvPtr )
            #c    => '(\s*)([^(]+)\s+(\S+)\s*\(.*\)',
            c => '(\s*)(?=.*(?:void|bool|int|short|long|double|char|size_t))([^(]+)\s+(\S+)\s*\(',
        },
        functionEnd => {
            awk   => '\s*}',
            bas   => '\s*end (function|sub)',
            c     => '\s*}',
            cpp   => '\s*}',
            dart  => '\s*}',
            for   => '\s*(function|program|subroutine) end',
            go    => '\s*}',
            java  => '\s*}',
            jl    => '\s*end',
            js    => '\s*}',
            kt    => '\s*}',
            lua   => '\s*end',
            m     => '\s*end',
            pas   => '\s*end',
            php   => '\s*}',
            pl    => '\s*}',
            py    => '\s*\S',
            r     => '\s*}',
            rb    => '\s*end',
            rs    => '\s*}',
            sc    => '\s*}',
            sh    => '\s*}',
            swift => '\s*}',
            tcl   => '\s*}',
            ts    => '\s*}',
            v     => '\s*(endfunction|endtask)',
        },
        functionCall => {
            awk   => '(\w+)\s*\(',
            bas   => '(?:call\s+)?(\w+)\s*\(',
            c     => '(\w+)\s*\(',
            cpp   => '(\w+)\s*\(',
            dart  => '(\w+)\s*\(',
            for   => '(\w+)\s*\(',
            go    => '(\w+)\s*\(',
            java  => '(\w+)\s*\(',
            jl    => '([\w\.\!\$]+)\s*\(',
            js    => '(\w+)\s*\(',
            kt    => '(\w+)\s*\(',
            lua   => '([\w\.]+)\s*\(',
            m     => '(\w+)\s*\(',
            pas   => '(\w+)\s*\(',
            php   => '(?<![\$])(\w+)\s*\(',        # (?< ...) is a negative lookahead assertion
            pl    => '(?<![\$\%\@])(\w+)\s*\(',    # while it's possible to call functions without the '(', this is not commonly done
            py    => '(\w+)\s*\(',
            r     => '(\w+)\s*\(',
            rb    => '(\w+)\s*',
            rs    => '(\w+)\s*\(',
            sc    => '(\w+)',
            sh    => '(\w+)',
            swift => '(\w+)\s*\(',
            tcl   => '(?<![\$])(\w+)\s*',
            ts    => '(\w+)\s*\(',
            v     => '(\w+)',
        },
        comment => {
            # Comments are removed
            awk   => '#',
            bas   => '^REM\s+',
            c     => '//',                       # doesn't handle multiline comments /* */
            cpp   => '//',                       # doesn't handle multiline comments /* */
            dart  => '//',                       # doesn't handle multiline comments /* */
            for   => '!',
            go    => '//',
            java  => '//',                       # doesn't handle multiline comments /* */
            js    => '//',
            kt    => '//',
            lua   => '--',
            jl    => '#',                        # doesn't handle multiline comments #= =#
            m     => '%',
            pas   => '(//|\{.*\}|\(\*.*\*\))',
            php   => '(//|#)',                   # doesn't handle multiline comments /* */
            pl    => '#',                        # unless $line =~ /s#[^#]+#[^#]+#/;
            py    => '#',
            r     => '#',
            rb    => '#',
            rs    => '//',
            sc    => '//',                       # doesn't handle multiline comments /* */
            sh    => '#',
            swift => '//',                       # doesn't handle multiline comments /* */
            tcl   => ';?\s*#',                   # remove comments and superfluous ';'
            ts    => '//',
            v     => '//',                       # doesn't handle multiline comments /* */
        },
        variable => {
            # This only affects the global variable searching with -verbose mode
            awk   => '(\w+)',
            bas   => '(\w+)',
            c     => '(\w+)',
            cpp   => '(\w+)',
            dart  => '(\w+)',
            for   => '(\w+)',
            go    => '(\w+)',
            java  => '(\w+)',
            jl    => '(\w+)',
            js    => '(\w+)',
            kt    => '(\w+)',
            lua   => '(\w+)',
            m     => '(\w+)',
            pas   => '(\w+)',
            php   => '[\$]\{?(\w+)',
            pl    => '[\$\@\%]\{?(\w+)',
            py    => '(\w+)',
            r     => '(\w+)',
            rb    => '(\w+)',
            rs    => '(\w+)',
            sc    => '(\w+)',
            sh    => '(\w+)',
            swift => '(\w+)',
            tcl   => '(\w+)',              # set foo $bar  <- one of the variables does not have a '$'
            ts    => '(\w+)',
            v     => '(\w+)',
        },
    };
    if ( !defined $languageSyntax->{functionDefinition}{$language} ) {
        say "ERROR:  Language '$language' not recognized.  Specify it with  -language <language>";
        say "        For example:  -language pl";
        say "        For example:  -language py";
        say "        For example:  -language tcl";
        say "        Supported languages are:  " . join ' ', sort keys %{ $languageSyntax->{functionDefinition} };
        exit 1;
    }
    return $languageSyntax;
}

sub parseFiles {
    # Create data structure of each function and the functions they call
    my %options        = @_;
    my $language       = $options{language};
    my $languageSyntax = $options{languageSyntax};
    my ( $file, $shebang, $in_pod, @funcName, @funcSpaces, $funcDefinition, $funcContents, $funcCall );
    for my $file ( @{ $options{files} } ) {
        open my $FH, $file or die "\nERROR:  Cannot find file $file\n";
        @funcName   = ($main);
        @funcSpaces = ('');
        my $fileContent = do { local $/; <$FH> };
        # Handle '\' line continuation characters
        $fileContent =~ s/\\\n//g;
        if ( $language =~ /^(c|cpp|java)$/ ) {
            # Convert ')\n{' to ') {', which is only needed for C/C++/Java
            $fileContent =~ s/\)\s*\n\s*{/) {/g;
        }
        my $lineNum = 0;
      LINE: for my $line ( split /\n/, $fileContent ) {
            $lineNum++;
            d '.';
            d '$lineNum';
            chomp($line);
            my $originalLine = $line;
            $shebang = $line if $lineNum == 1 and $line =~ /^#!/;
            next if $line =~ /^\s*(#.*)?$/;    # skip empty lines and whole-line comments
            d '$line';

            if ( $language eq 'pl' ) {
                if ( $line =~ /^__END__/ ) {
                    last LINE;
                }
                # Skip Perl POD documentation
                if ( $line =~ /^=(\w+)/ ) {
                    $in_pod = ( $1 eq 'cut' ) ? 0 : 1;
                    next;
                }
                next if $in_pod;
            }

            # Remove comments.  This is not 100% optimal, as '#' may exist in the middle of a "string"
            if ( $language eq 'pl' ) {
                $line =~ s/\s*$languageSyntax->{comment}{$language}.*// unless $line =~ /s#[^#]+#[^#]+#/;
            } else {
                $line =~ s/\s*$languageSyntax->{comment}{$language}.*//;
            }

            # Perl sub, TCL proc, Python/Ruby def
            if ( $line =~ /^$languageSyntax->{functionDefinition}{$language}/i ) {
                my $leadingSpaces = $1;
                my $funcKeyword   = $2;
                my $funcName      = $3;
                #my $junk4 = $4;
                #my $junk5 = $5;
                #my $junk6 = $6;
                #my $junk7 = $7;
                #d '$leadingSpaces $funcKeyword $funcName $junk4 $junk5 $junk6 $junk7';
                # TCL proc may start with or contain '::'
                $funcName =~ s/^.*://;    # Remove package::
                d "Found start of function '$funcName'";
                if ( $funcName eq '' ) {
                    # TCL proc ::$name dynamic definitions
                    say "Found dynamically generated proc at line $lineNum of $file.  The call graph will show an empty bubble.";
                }
                $funcDefinition->{$funcName}{$file}{line} = $lineNum;
                $funcContents->{$funcName}{$file} = "$line\n";
                if ( $language eq 'py' ) {
                    # Python does not mark the end of functions.  Can't support the parsing of nested functions
                    @funcName   = ( '__MAIN__', $funcName );
                    @funcSpaces = ( '',         $leadingSpaces );
                } elsif ( $line =~ /}\s*(;\s*)?(#.*)?$/ and $language !~ /(jl)/ ) {
                    d 'function has started and ended on the same line, do not push';
                    # proc d {args} {}
                    # sub say { print @_, "\n" }; # comment
                } else {
                    push @funcName,   $funcName;
                    push @funcSpaces, $leadingSpaces;
                }
                #d '@funcName @funcSpaces';
                next;
            }

            # End of sub or proc
            d( '@funcName $funcName[-1] $main @funcSpaces', 'z' );
            if ( $funcName[-1] eq $main ) {
                $funcContents->{ $funcName[-1] }{$file} .= "$line\n";
            } else {
                # Current sub name is not __MAIN__
                # Note that this implementation could be fooled by multiline strings
                if ( $line =~ /^$languageSyntax->{functionEnd}{$language}/i and $line =~ /^$funcSpaces[-1]\S/ ) {
                    d "Found end of function $funcName[-1]";
                    if ( $funcSpaces[0] eq '' ) {
                        if ( $language eq 'py' ) {
                            # In Python, there is no '}' to buffer the end of one function from the beginning of the next
                            $funcContents->{$main}{$file} .= "$line\n";
                        } else {
                            # This is a tweak designed to potentially recover from incorrect parsing
                            # If the function starts at the left border, then assume it was not nested in the middle of some other function
                            $funcContents->{ $funcName[-1] }{$file} .= "$line\n";
                        }
                        @funcName   = ($main);
                        @funcSpaces = ('');
                    } else {
                        $funcContents->{ $funcName[-1] }{$file} .= "$line\n";
                        pop @funcName;
                        pop @funcSpaces;
                    }
                } else {
                    $funcContents->{ $funcName[-1] }{$file} .= "$line\n";
                }
            }

            # Find anything that looks like it might be a function, casting a very wide net
            while ( $line =~ s/^.*?$languageSyntax->{functionCall}{$language}//i ) {
                my $call = $1;
                if ( $language =~ /^(tcl|pl)$/ ) {
                    $call =~ s/^.*://;    # Remove package::
                }
                $funcCall->{ $funcName[-1] }{$file}{$call}++;
                d "Found potential function call:  $call";
            }

            $line =~ s/[\$\%\@]//g;       # To enhance the following debug statement
            d "remain:  $line" if $line =~ /\S/;    # inspect remainder not caught by the above regex
        }
    }
    return ( $shebang, $funcContents, $funcDefinition, $funcCall );
}

my $languageSyntax = defineSyntax($language);
my ( $shebang, $funcContents, $funcDefinition, $funcCall ) = parseFiles( language => $language, languageSyntax => $languageSyntax, files => \@files );
d '$funcDefinition';                                # $funcDefinition->{$funcName}{$file}{line}  = line_number
d '$funcCall';                                      # $funcCall->{$funcName}{$file}{$word} = occurrences
#d '$funcContents';    # $funcContents->{$funcName}{$file} = contents (long)

# Experimental feature -writeFunctions
# Optionally create an output source file for each function in the source file(s)
if ( 1 and $opt{writeFunctions} ) {
    writeFunctions();
}

sub writeFunctions {
    my %options;
    #$options{destDir} = "/tmp/foo";
    #$options{removeComments} = 1;
    #$options{grep} = 'get_name';
    #$options{grep} = 'global';
    $options{sort} = 1;
    say "\n### Grepping for $options{grep} ###";    # TODO remove this
                                                    #$options{reverse} = 1;
                                                    #$options{numOccurrences} = 1;
                                                    #my $d = 1;
                                                    #d '$funcContents';
    my %matched;
    for my $func ( keys %{$funcContents} ) {
        d '$func';
        for my $file ( keys %{ $funcContents->{$func} } ) {
            d '$file';
            if ( defined $options{grep} ) {
                for my $line ( split /\n/, $funcContents->{$func}{$file} ) {
                    d '$line';
                    if ( $line =~ /$options{grep}/ ) {
                        $line =~ s/^\s*//;
                        $matched{$file}{$func}{occurrences}++;
                        push @{ $matched{$file}{$func}{contents} }, '    ' . $line;
                    }
                }
                d '%matched';
            } else {
                my $bfile = basename($file);
                my $ext   = '';
                if ( $bfile =~ /(.*)(\..*)$/ ) {
                    ( $bfile, $ext ) = ( $1, $2 );
                }
                my $functionFile = "$tmpdir/${bfile}__${func}${ext}";
                say "Creating function source file $functionFile";
                open( my $OUT, ">", $functionFile ) or die "\nERROR: Cannot open file for writing:  $functionFile\n";
                print $OUT $funcContents->{$func}{$file};
                close $OUT;
                `chmod +x $functionFile`;
                #say `ls -l $subsetFile`; # commented because of regressions
            }
        }
    }
    #exit 0;
    if ( defined $options{grep} ) {
        my $format;
        if ( scalar keys %matched == 1 ) {
            $format = "%s  %s\n";
        } else {
            $format = "%s  %s  %s\n";
        }
        my $printFilename = scalar keys %matched > 1 ? 1 : 0;
        d '%matched $printFilename';
        for my $file ( sort keys %matched ) {
            my @sorted = sort { $matched{$file}{$a}{occurrences} <=> $matched{$file}{$b}{occurrences} } keys %{ $matched{$file} };
            @sorted = reverse @sorted if $options{reverse};
            for my $func (@sorted) {
                if ($printFilename) {
                    printf( $format, $file, $func, $matched{$file}{$func}{occurrences} );
                } else {
                    printf( $format, $func, $matched{$file}{$func}{occurrences} );
                }
                if ( !$options{numOccurrences} ) {
                    if ( $options{sort} ) {
                        say( join "\n", sort @{ $matched{$file}{$func}{contents} } );
                    } else {
                        say( join "\n", @{ $matched{$file}{$func}{contents} } );
                    }
                }
            }
        }
    }
    exit 0;
}

# Match callers with callees
# first:    try to find a match within the same file.
# second:   see if the function is defined in ONE other file
# third:    complain about an ambiguous call if the callee has multiple definitions
for my $caller_sub ( keys %{$funcCall} ) {
    next if ( defined $opt{ignore} and $caller_sub =~ /$opt{ignore}/ );
    for my $caller_file ( keys %{ $funcCall->{$caller_sub} } ) {
        for my $referenced_sub ( keys %{ $funcCall->{$caller_sub}{$caller_file} } ) {
            next unless ( exists $funcDefinition->{$referenced_sub} );
            next if ( defined $opt{ignore} and $referenced_sub =~ /$opt{ignore}/ );

            if ( exists $funcDefinition->{$referenced_sub}{$caller_file} ) {
                $call_graph->{"$caller_file:$caller_sub"}{calls}{"$caller_file:$referenced_sub"}++;
                $call_graph->{"$caller_file:$referenced_sub"}{called_by}{"$caller_file:$caller_sub"}++;
                next;
            }
            my (@matching_definitions) = sort keys %{ $funcDefinition->{$referenced_sub} };

            if ( @matching_definitions == 1 ) {
                my $referenced_file = shift @matching_definitions;
                $call_graph->{"$caller_file:$caller_sub"}{calls}{"$referenced_file:$referenced_sub"}++;
                $call_graph->{"$referenced_file:$referenced_sub"}{called_by}{"$caller_file:$caller_sub"}++;
            } else {
                # say( "AMBIGUOUS: $caller_file:$caller_sub() -> $referenced_sub() defined in @matching_definitions" );
            }
        }
    }
}
d '$call_graph';

INTERMEDIATE_FORMAT:
if ( $opt{ymlOut} ) {
    eval 'use YAML::XS ()';
    if ($@) {
        say "\n$@\n";
        say "ERROR:  Install YAML::XS to use option -ymlOut";
        say "        sudo cpan install YAML::XS";
        exit 1;
    } else {
        say "Creating file $opt{ymlOut}";
        YAML::XS::DumpFile( $opt{ymlOut}, $call_graph );
    }
}

if ( $opt{obfuscate} ) {
    my %cache;
    #my @gibberish = qw(aerate amplify approximate assemble benchmark calculate compile compress decode defrag delete download emulate encapsulate encode enhance exaggerate grep hypothesize infer inspect interpolate multiplex mutate obfuscate predict process procrastinate profile prune refactor rewind smite spawn swizzle transform translate);
    my @gibberish = qw( abscond acknowledge aerate amplify approximate assemble benchmark bite blast boast boil boost broadcast build burn burrow calculate captivate capture charge chortle climb clone communicate compile compress crash create crush curse decode decorate defrag delete demoralize demystify desalinate detonate devour differentiate disinfect disintegrate divulge download edit elevate embezzle emulate emulsify encapsulate enchant encode energize enhance enjoy enlarge erase exaggerate exfoliate experiment explain explode explore extract exude falsify fight flutter forecast fumble fundraise generate gerrymander grep growl hatch hover howl hurry hyperventilate hypothesize illuminate improvise infer inherit inquire insert inspect instantiate interpolate ionize irradiate jostle jump lather leap liquefy locate magnify message mock-up modify multiplex mutate obfuscate obtain overdeliver oxidize pander panic parse pasteurize peek plunder poke pontificate postulate predict process procrastinate profile propose prune publish quench refactor refine refuel relax repair repeat replace reschedule revolve rewind rinse roar ruin sanitize sautee scan schedule scorch scrape search seize self-medicate serve shatter shred shrink sizzle slash sleep slurp smack smite snarl snoop socialize soothe spawn speculate squeal squeeze steer sterilize stretch struggle strut stumble stutter submit subvert superimpose supersize surprise swindle swipe swizzle taunt teleport tenderize test tilt titrate toast transform translate trim untangle upload vaccinate validate vaporize wait warp whimper whisper yell );
    if ( defined $ENV{SEED} ) {
        # Should be an integer
        srand( $ENV{SEED} );
    }
    $call_graph = renameFunctions( $call_graph, { cache => \%cache, ignore => [qw( __MAIN__ )], jargon => \@gibberish } );

    sub renameFunctions {
        my ( $in, $options ) = @_;
        my $new;
        my $numFunctions = scalar keys %{$in};
        my $numMapped    = scalar @{ $options->{jargon} };
        my $numSkipped   = @{ $options->{ignore} };
        d '$in $options $numFunctions $numMapped';
        say "$numFunctions function names (including __MAIN__)";
        say "$numSkipped function names will not be mapped";
        say "$numMapped obfuscated names in the jargon list";
        say "WARNING:  Obfuscation needs a bigger word list, will use random words" if $numFunctions > ( $numMapped + $numSkipped );

        for my $from_file_sub ( keys %{$in} ) {
            my ( $from_file, $from_sub ) = split( /:/, $from_file_sub );
            my $from_sub_new = transformVerbs( $from_sub, $options );
            for my $calls_or_called_by ( keys %{ $in->{$from_file_sub} } ) {
                for my $to_file_sub ( keys %{ $in->{$from_file_sub}{$calls_or_called_by} } ) {
                    my ( $to_file, $to_sub ) = split( /:/, $to_file_sub );
                    my $to_sub_new = transformVerbs( $to_sub, $options );
                    $new->{"$from_file:$from_sub_new"}{$calls_or_called_by}{"$to_file:$to_sub_new"} = $in->{"$from_file:$from_sub"}{$calls_or_called_by}{"$to_file:$to_sub"};
                }
            }
        }
        d '$new';
        return $new;
    }

    sub transformVerbs {
        my ( $name, $options ) = @_;
        my $cache = $options->{cache};
        my $new;
        if ( defined $cache->{$name} ) {
            # We've seen this one before
            $new = $cache->{$name};
        } elsif ( grep( /^$name$/, @{ $options->{ignore} } ) ) {
            # Keep the same name
            $new = $name;
            $cache->{$name} = $new;
        } elsif ( !scalar @{ $options->{jargon} } ) {
            # The word list has been used up, think of a random word
          SCRABBLE:
            my @letters = split //, 'aaaaaaaaabbccddddeeeeeeeeeeeeffgggghhiiiiiiiiijkllllmmnnnnnnooooooooppqrrrrrrssssttttttuuuuvvwwxyyz';
            my $name = join '', @letters[ map rand @letters, 1 .. 9 ];
            goto SCRABBLE if defined $cache->{$name};    # Don't re-use any random words
            $new = $name;
            $cache->{$name} = $new;
        } else {
            # Grab a name out of the bag
            my $i = rand( @{ $options->{jargon} } );
            $new = $options->{jargon}[$i];
            $options->{jargon}[$i] = undef;    # Ensure that same name is not mapped twice
            @{ $options->{jargon} } = grep { defined($_) } @{ $options->{jargon} };
            $cache->{$name} = $new;
        }
        return $new;
    }
}

# Determine which nodes to start graphing from
my @initial_nodes = ();
if ( defined $opt{start} ) {
    # The keys of $call_graph are "$filename_including_path:$function"
    @initial_nodes = sort grep( /$opt{start}/i, keys %{$call_graph} );
} else {
    for my $file_sub ( sort keys %{$call_graph} ) {
        my ( $file, $sub ) = split( /:/, $file_sub );
        unless ( $call_graph->{$file_sub}{called_by} ) {
            push( @initial_nodes, $file_sub );
        }
    }
}
d '@initial_nodes';    # If there are unused subroutines, they will show up here
if ( $opt{regression} ) {
    print Data::Dumper->Dump( [ $funcDefinition, $funcCall, $call_graph ], [qw(funcDefinition funcCall call_graph)] );
}

unless ( $opt{ymlIn} ) {
    my $numFuncDefinitions = scalar keys %$funcDefinition;
    if ( !$numFuncDefinitions or !@initial_nodes ) {
        if ( defined $opt{start} ) {
            say "\nERROR:  Could not find any functions which match '$opt{start}'\n";
        } else {
            #say "Function definitions: " . join "\n", sort keys %$funcDefinition if $verbose;
            if ($numFuncDefinitions) {
                say "\nERROR:  Found $numFuncDefinitions function definitions, but could not find any matching function calls in your file";
            } else {
                say "\nERROR:  Could not find any function definitions in your file";
            }
            if ( $language !~ /^(tcl|pl|py)$/ ) {
                say "        It is possible that $scriptName is not searching for them correctly in your .$language file";
                say "        It parses one line at a time, using this regular expression for function definitions:";
                say "            ^$languageSyntax->{functionDefinition}{$language}";
                say "        and using this regular expression for function calls:";
                say "            $languageSyntax->{functionCall}{$language}";
                say "        To enhance the regular expression, edit the code which defines the 'languageSyntax' for 'functionDefinition' and/or 'functionCall',";
                say "          and ensure that the function name is captured in the 3rd group of the definition'\n";
            }
        }
        exit 1;
    }
}

# Produce the graph
my $graph = graph->new(
    'call_graph'    => $call_graph,
    'dot_name'      => $dot,
    'cluster_files' => $opt{cluster},
    'generate_dot'  => 1,
);

for my $file_sub (@initial_nodes) {
    $graph->plot($file_sub);
}
d '$graph';
d '$graph->{node}';

# Verbose mode to inspect global variables:
#     Only analyze the subroutines included in the graph
#     For each function:
#         Perl:
#             determine which variables are local to each sub (my)
#             compare these with the variables used
#             then determine which global variables are used
#             If script does not use 'my' variables, then Python rules are used
#         Python:
#             Any variables defined in __MAIN__ are globals
#         TCL:
#             parses 'global' statements and global $::foo variables
if ( $opt{ymlIn} ) {
    # do nothing
} elsif ( $opt{verbose} ) {
    d 'verbose';
    my %sub_info;
    my $perl_my_var_found;
    my $externalScriptCallsFound;
    # Add main function to list
    my @file_subs = ( sort keys %{ $graph->{node} } );
    for my $file_sub ( sort @file_subs ) {
        d '$file_sub';
        my ( $file, $sub ) = split( /:/, $file_sub );
        d '$file $sub';
        if ( !grep( /$file:$main/, @file_subs ) ) {
            push @file_subs, "$file:$main";
        }
    }
    d '@file_subs';
    for my $file_sub ( sort @file_subs ) {
        my ( $file, $sub ) = split( /:/, $file_sub );
        d '.';
        d '.';
        d '$file $sub';
        if ( $language eq 'pl' ) {
            for my $line ( split /\n/, $funcContents->{$sub}{$file} ) {
                d '.';
                d '$line';
                my $originalLine = $line;

                # Find 'my' vars
                $line =~ s/"[^"]+?"//g;    # Remove anything in "quotes", nongreedy
                d '$line';
                if ( $line =~ /\s*(my|our)\s+\(([^)]+)/ ) {
                    # my ($var2, @varA3) = @_;
                    my $localVars = $2;
                    d '$localVars';
                    $perl_my_var_found = 1;
                    for my $localVar ( split /\s*,\s*/, $localVars ) {
                        $localVar =~ s/[\$\@\%]//;
                        d '$localVar';
                        next if $localVar =~ /^(_|\d)$/;
                        $sub_info{$file}{$sub}{localVars}{$localVar}++;
                    }
                } elsif ( $line =~ /\b(my|our)\s+[\$\@\%](\w+)/ ) {
                    # my $var1 = shift;
                    # chomp(my %varH4 = foo());
                    my $localVar = $2;
                    d '$localVar';
                    $perl_my_var_found = 1;
                    next if $localVar =~ /^(_|\d)$/;
                    $sub_info{$file}{$sub}{localVars}{$localVar}++;
                } else {
                    # do nothing
                    d 'no my vars declared';
                }

                # Find anything which might be a var
                # $var @var %var ${var}
                d '$originalLine';
                while ( $originalLine =~ s/$languageSyntax->{variable}{$language}// ) {
                    my $var = $1;
                    # $globalRunCount++;
                    d '$var';
                    d '$originalLine';
                    next if $var =~ /^(_|\d+)$/;
                    $sub_info{$file}{$sub}{vars}{$var}++;
                }
            }
        } elsif ( $language =~ /^(tcl)$/ ) {
            d '$funcContents->{$sub}{$file}';
            for my $line ( split /\n/, $funcContents->{$sub}{$file} ) {
                if ( $line =~ /^\s*global\s+(.*\S)\s*$/ ) {
                    # Find global var declarations
                    d '$line';
                    my $usedGlobalVars = $1;
                    for my $globalvar ( split /\s+/, $usedGlobalVars ) {
                        $globalvar =~ s/\W.*//;    # Remove junk at end:  ;
                        next if $globalvar =~ /^\s*$/;
                        $sub_info{$file}{$sub}{declaredGlobalVars}{$globalvar}++;
                    }
                } else {
                    # Find used global vars such as ::var
                    while ( $line =~ s/\$::(\S+)// ) {
                        ( my $word = $1 ) =~ s/\W.*//;    # Remove junk at end:  ; (...)  etc
                        next if $word =~ /^\s*$/;
                        $sub_info{$file}{$sub}{usedGlobalVars}{$word}++;
                    }
                    # Find anything which might be a var
                    # $var ${var}
                    d '$line';
                    while ( $line =~ s/$languageSyntax->{variable}{$language}// ) {
                        my $var = $1;
                        d '$var';
                        d '$line';
                        next if $var =~ /^\d+$/;
                        $sub_info{$file}{$sub}{vars}{$var}++;
                    }
                }
            }
            d '$sub_info{$file}{$sub}';
        } else {
            # Python, etc
            for my $line ( split /\n/, $funcContents->{$sub}{$file} ) {
                d '.';
                d '$line';
                my $originalLine = $line;
                # Find anything which might be a var
                # $var @var %var ${var}
                d '$originalLine';
                while ( $line =~ s/$languageSyntax->{variable}{$language}// ) {
                    my $var = $1;
                    #'    globalRunCount = globalRunCount + 1
                    d '$var';
                    d '$originalLine';
                    next if $var =~ /^(\d+)$/;
                    $sub_info{$file}{$sub}{vars}{$var}++;
                }
            }
        }
        for my $line ( split /\n/, $funcContents->{$sub}{$file} ) {
            if ( $line =~ /(\w+\.(awk|m|js|php|pl|py|r|rb|sc|sh|tcl)\b)/ ) {
                my $script = $1;
                if ( basename($file) ne $script ) {
                    $sub_info{$file}{$sub}{scriptsCalled}{$script}++;
                    $externalScriptCallsFound++;
                }
            }
        }
    }
    d '%sub_info';
    if ( $language =~ /^(tcl)$/ ) {
        # declaredGlobalVars usedGlobalVars vars
        # determine perl $sub_info{$file}{$sub}{usedGlobalVars}
        # for each sub:
        #    if var is used in function and not defined as 'my' in the same function, and if it is defined as 'my' in the main function, then it's probably a global
        for my $file_sub ( sort keys %{ $graph->{node} } ) {
            my ( $file, $sub ) = split( /:/, $file_sub );
            d '$sub';
            d '$sub_info{$file}{$sub}';
            for my $var ( keys %{ $sub_info{$file}{$sub}{declaredGlobalVars} } ) {
                if ( defined $sub_info{$file}{$sub}{vars}{$var} ) {
                    $sub_info{$file}{$sub}{usedGlobalVars}{$var} = 1;
                } else {
                    # Variable was declared as global, but never used
                    $sub_info{$file}{$sub}{usedGlobalVars}{"$var *"} = 1;
                }
            }
            d '$sub_info{$file}{$sub}';
            #delete $sub_info{$file}{$sub}{vars};
            #delete $sub_info{$file}{$sub}{declaredGlobalVars};
        }
    } else {
        # Perl, Python, etc
        # determine perl $sub_info{$file}{$sub}{usedGlobalVars}
        # for each sub:
        #    if var is used the in function, and not defined as 'my' in the same function, and if it is a 'my' variable in the main function, then it is considered to be global
        if ( $language eq 'pl' ) {
            if ( !$perl_my_var_found ) {
                say "WARNING:  Did not find Perl 'my' variables, so global variable detection will have many false positives";
            }
        } else {
            say "WARNING:  Global variable detection for .$language will have many false positives";    # such as any language keywords used in both the main program and the function
        }
        for my $file_sub ( sort @file_subs ) {
            my ( $file, $sub ) = split( /:/, $file_sub );
            d '$sub';
            for my $var ( keys %{ $sub_info{$file}{$sub}{vars} } ) {
                if ($perl_my_var_found) {
                    if ( defined $sub_info{$file}{$sub}{vars}{$var} and not defined $sub_info{$file}{$sub}{localVars}{$var} and ( defined $sub_info{$file}{$main}{vars}{$var} or $var =~ /^(ARGV|ENV|INC|SIG)$/ ) ) {
                        $sub_info{$file}{$sub}{usedGlobalVars}{$var} = 1;
                    }
                } else {
                    if ( defined $sub_info{$file}{$sub}{vars}{$var} and not defined $sub_info{$file}{$var} and ( defined $sub_info{$file}{$main}{vars}{$var} or $var =~ /^(ARGV|ENV|INC|SIG)$/ ) ) {
                        if ( $language eq 'py' and $var =~ /^(False|None|True|and|as|assert|async|await|break|class|continue|csv|datetime|def|del|elif|else|except|finally|for|from|global|gz|if|import|in|is|lambda|nonlocal|not|np|or|pass|raise|re|return|try|while|with|yield|\d+|__\S+__|all|args|at|basename|by|collections|cwd|date|datetime|dict|each|end|error|exists|f|file|files|find|format|get|getcwd|group|help|i|include|int|key|len|limit|map|match|math|matlib|numpy|object|open|os|path|pd|plt|print|r|random|reduce|rename|replace|size|str|strip|subprocess|sys|time|using|w|warning|yaml)$/ ) {
                            # do nothing, keyword or probably not a global variable name
                        } else {
                            $sub_info{$file}{$sub}{usedGlobalVars}{$var} = 1;
                        }
                    }
                }
            }
            if ( $sub eq $main ) {
                $sub_info{$file}{$main}{usedGlobalVars} = $sub_info{$file}{$main}{localVars} if defined $sub_info{$file}{$main}{localVars};
                d '$sub_info{$file}{$main}';
            }
            #delete $sub_info{$file}{$sub}{vars};
            #delete $sub_info{$file}{$sub}{localVars};
        }
    }
    d '%sub_info';

    if ( $language eq 'tcl' ) {
        say "\nGlobal variables used in each function (global variables declared but not used are marked with a '*'):";
    } else {
        say "\nGlobal variables used in each function:";
    }
    for my $file ( sort keys %sub_info ) {
        say "    $file";
        for my $sub ( sort keys %{ $sub_info{$file} } ) {
            say "        $sub";
            if ( $language =~ /^(tcl|pl|py)$/ ) {
                for my $var ( sort keys %{ $sub_info{$file}{$sub}{usedGlobalVars} } ) {
                    say "            $var";
                }
            }
        }
    }

    # TODO - list functions not shown in graph, need to test this, this will make regressions fail
    # ### put the logic to detect these earlier, and then print then based on file/sub  (not sub/file)
    if (0) {
        say "\nFunctions which are not called by any function, and do not call other functions:";
        for my $func ( sort keys %{$funcContents} ) {
            d '$func';
            for my $file ( sort keys %{ $funcContents->{$func} } ) {
                d '$file';
                # %sub_info{$file}{$func} is derived from $graph->{node}
                # $funcContents->{$func}{$file};
                if ( defined $sub_info{$file}{$func} ) {
                    # do nothing
                } elsif ( defined $opt{ignore} and $func =~ /$opt{ignore}/ ) {
                    # do nothing
                } elsif ( $language eq 'pl' and $func eq 'say' ) {
                    # do nothing
                } else {
                    $sub_info{$file}{$func}{notConnected}++;
                }
            }
        }
        d '%sub_info';
        for my $file ( sort keys %sub_info ) {
            say "    " . basename($file) if @files > 1;
            for my $func ( sort keys %{ $sub_info{$file} } ) {
                say "        $func" if $sub_info{$file}{$func}{notConnected};
            }
        }
        say "";
    }

    # Find external scripts referenced in each function
    if ($externalScriptCallsFound) {
        say "\nExternal scripts referenced in each function:";
        for my $file ( sort keys %sub_info ) {
            say "    " . basename($file);
            for my $sub ( sort keys %{ $sub_info{$file} } ) {
                if ( $sub_info{$file}{$sub}{scriptsCalled} ) {
                    say "        $sub";
                    for my $script ( sort { $a cmp $b } keys %{ $sub_info{$file}{$sub}{scriptsCalled} } ) {
                        say "            $script";
                    }
                }
            }
        }
        say "";
    }
} else {
    if ( $language =~ /^(pl|tcl)$/ ) {
        say "To see a report on global variables, use the -verbose option";
    }
}

# -writeSubsetCode
# Optionally create an output source file which includes only the subroutines included in the graph
if ( $opt{writeSubsetCode} ) {
    #my $subsetFile = "$opt{writeSubsetCode}.$language";
    my $subsetFile = "$opt{writeSubsetCode}";
    say "\nCreating subset source file $subsetFile";
    open( my $OUT, ">", $subsetFile ) or die "\nERROR: Cannot open file for writing:  $subsetFile\n";
    print $OUT "$shebang\n" if defined $shebang;
    for my $file_sub ( sort keys %{ $graph->{node} } ) {
        my ( $file, $sub ) = split( /:/, $file_sub );
        d '$file $sub';
        next if $sub eq $main;    # Don't want main to clutter it up
        print $OUT $funcContents->{$sub}{$file};
    }
    close $OUT;
    `chmod +x $subsetFile`;
    #say `ls -l $subsetFile`; # commented because of regressions
}

#exit 0 if $opt{regression};

# Attempt to convert .dot to .svg or .png or .pdf, using system resources
if ( $output =~ /\.dot$/ ) {
    # do nothing
} else {
    if ( !defined whichCommand('dot') ) {
        say "\nERROR:  The executable 'dot' cannot be found in your path";
        if ( -d '/home/ckoknat' ) {
            say "        Try running on a RedHat/CentOS 5 or 6 machine, such as sc-xterm-60\n";
        } else {
            say "        Run this to proceed:";
            say "            sudo apt install graphviz\n";
        }
        exit 1;
    }
}

# Create the graph
$graph->generate();
ls $dot;

# Attempt to convert .dot to .svg or .png or .pdf, using system resources
if ( $output =~ /\.dot$/ ) {
    # do nothing
} else {
    my ( $image, $cmd );
    if ( $output =~ /\.svg$/ ) {
        ( $image = $dot ) =~ s/\.dot$/.svg/;
        $cmd = "dot -Tsvg $dot -o $image";
    } elsif ( $output =~ /\.pdf$/ ) {
        ( $image = $dot ) =~ s/\.dot$/.pdf/;
        $cmd = "dot -Tpdf $dot -o $image";
    } else {
        # png is default
        # svg is much quicker, but for bigger graphs, the function names are not contained completely within the ovals
        ( $image = $dot ) =~ s/\.dot$/.png/;
        $cmd = "dot -Tpng $dot -o $image";
    }
    d '$cmd';
    say "Converting to $image";
    my $result = `$cmd`;
    say $result if $result =~ /\S/;
    ls $image;
    #say `ls -l $image`;  # commented because of regressions
    unless ( $opt{noShow} ) {
        my $displayExecutable;
        if ( $output =~ /\.pdf$/ ) {
            $displayExecutable = whichCommand( 'evince', 'gs' );
        } else {
            # eog is nice because it has zoom in/out
            $displayExecutable = whichCommand( 'eog', 'eom', 'fim', 'feh', 'xdg-open', 'open', 'konqueror', 'gwenview', 'display', 'xv' );
        }
        if ( defined $displayExecutable ) {
            $cmd = "$displayExecutable $image";
            d '$cmd';
            say "Displaying $image using '$displayExecutable'";
            say `$cmd 2>/dev/null &`;
        } else {
            say "WARNING:  Could not find a command to display $image";
            exit 0;
        }
    }
}
exit 0;

sub getScriptType {
    my %options = @_;
    d '%options';
    my $file = $options{file};
    $file =~ s/#.*//;    # Remove p4 rev number
    my $filetype;
    if ( $file =~ /\.(awk|bas|c|cpp|dart|for|go|java|jl|js|kt|lua|m|pas|php|pl|py|r|rb|rs|sc|sh|swift|tcl|ts|v)$/i ) {
        $filetype = lc($1);
        return $filetype;
    } elsif ( $file =~ /\.basic$/ ) {
        return 'bas';
    } elsif ( $file =~ /\.cc$/ ) {
        return 'cpp';
    } elsif ( $file =~ /\.(f\d+|fypp|fortran)$/ ) {
        return 'for';
    } elsif ( $file =~ /\.(gy|gvy|groovy)$/ ) {
        return 'java';
    } elsif ( $file =~ /\.p6$/ ) {
        return 'pl';
    } elsif ( $file =~ /\.pm$/ ) {
        return 'pl';
    } elsif ( $file =~ /\.raku(mod)?$/ ) {
        return 'pl';
    } elsif ( $file =~ /\.scala$/ ) {
        return 'sc';
    } elsif ( $file =~ /\.sv$/ ) {
        return 'v';
    } elsif ( $file =~ /\.tn$/ ) {
        return 'tcl';
    } elsif ( $file =~ /\.vb$/ ) {
        return 'bas';
    } else {
        # Filename does not have a recognized extension.  Look at the shebang
        if ( -f $file ) {
            chomp( my $line = `grep '^#!' $file | head -n 1` );
            d '$line';
            if ( $line =~ m{^\#!(\S+/env\s+)?(\S+)} ) {
                # #!/usr/bin/python
                # #!/usr/bin/env python
                $filetype = basename($2);
                d '$filetype';
            }
        }
    }
    d '$filetype';
    if ( defined $filetype ) {
        # from shebang
        if ( $filetype =~ /^(node|nodejs)$/ ) {
            return 'js';
        } elsif ( $filetype =~ /^perl6?$/ ) {
            return 'pl';
        } elsif ( $filetype =~ /^python[0-9.]*$/ ) {
            return 'py';
        } elsif ( $filetype =~ /^ruby$/ ) {
            return 'rb';
        } elsif ( $filetype =~ /^tn_shell$/ ) {
            return 'tcl';
        }
    }
    if ( $options{scriptsOnly} ) {
        return '';
    } else {
        ( $filetype = $file ) =~ s/.*\.//;
        return $filetype;
    }
}

sub whichCommand {
    my @executableAndOptionsArray = @_;
    for my $executableAndOptions (@executableAndOptionsArray) {
        ( my $executable = $executableAndOptions ) =~ s/^(\S+).*/$1/;    # Strip any options before using 'which'
        chomp( my $which = `which $executable 2> /dev/null` );
        return $executableAndOptions if $which ne '';
    }
    return undef;
}

package graph;
# Debugger from CPAN
sub say { print @_, "\n" }
sub D   { say "Debug::Statements has been disabled" }
sub d   { }
sub ls  { }
#use lib "/home/ate/scripts/regression";
#use Debug::Statements ":all";

sub new {
    my $class = shift;
    my $self = bless {@_}, $class;
    return $self;
}

sub plot {
    my $self          = shift;
    my $from_file_sub = shift;
    my $direction     = shift || undef;    # up, down or undefined

    $self->{'node'}{$from_file_sub}++;
    unless ( defined $direction ) {
        $self->{'initial_node'}{$from_file_sub}++;
        $direction = "up down";
    }

    if ( $direction =~ /up/ ) {
        for my $parent_file_sub ( sort keys %{ $self->{'call_graph'}{$from_file_sub}{'called_by'} } ) {
            $self->{'edge'}{$parent_file_sub}{$from_file_sub}++;
            $self->plot( $parent_file_sub, 'up' ) unless $self->{'node'}{$parent_file_sub}++;
        }
    }

    if ( $direction =~ /down/ ) {
        for my $to_file_sub ( sort keys %{ $self->{'call_graph'}{$from_file_sub}{'calls'} } ) {
            $self->{'edge'}{$from_file_sub}{$to_file_sub}++;
            $self->plot( $to_file_sub, 'down' ) unless $self->{'node'}{$to_file_sub}++;
        }
    }
}

sub generate {
    my $self = shift;

    my $graph = GraphViz->new(
        rankdir     => 1,                         #  1 = left to right, 0 = top to bottom
        concentrate => 1,                         #  concentrate overlapping lines
        ratio       => 0.7,                       #  make the image 20% wider
        fontsize    => 24,                        # was 24
        node        => { shape => 'Mrecord', },
    );

    for my $file_sub ( sort keys %{ $self->{'node'} } ) {
        my ( $file, $sub ) = split( /:/, $file_sub );
        $file = File::Basename::basename($file) unless $opt{fullPath};
        my $cluster_id = defined $file ? "cluster_$file" : "cluster";
        #d '$file $sub';

        if ( $self->{'cluster_files'} and not $self->{'clusters'}{$cluster_id} ) {
            $self->{'clusters'}{$cluster_id} = {
                label     => $file,
                style     => "bold",
                fontname  => "Times-Bold",
                fontsize  => 48,             # was 48
                fontcolor => "red",
            };
        }

        my %node_attributes = ();

        if ( @files > 1 ) {
            $node_attributes{'label'} =
              $self->{'cluster_files'}
              ? sprintf( "%s", $sub )
              : sprintf( "%s\n%s", $file, $sub );
        } else {
            $node_attributes{'label'} = sprintf( "%s", $sub );
        }

        # highlight the start node(s)
        if ( exists $self->{'initial_node'}{$file_sub} ) {
            $node_attributes{'style'}     = 'filled';
            $node_attributes{'fillcolor'} = '/greens3/2';    # background, first green in greens3 colorscheme
            $node_attributes{'color'}     = '/greens3/3';    # border, last green in greens3 colorscheme
        }
        $node_attributes{'cluster'} = $self->{'clusters'}{$cluster_id} if $self->{'cluster_files'};

        $graph->add_node( $file_sub, %node_attributes );
    }

    for my $from_file_sub ( keys %{ $self->{'edge'} } ) {
        for my $to_file_sub ( keys %{ $self->{'edge'}{$from_file_sub} } ) {
            $graph->add_edge( $from_file_sub, $to_file_sub );
        }
    }
    if ( $self->{'generate_dot'} ) {
        printf "Generating: %s\n", $self->{'dot_name'};
        $graph->as_text( $self->{'dot_name'} );
    }
}

__END__
callGraph by Chris Koknat  https://github.com/koknat/callGraph
v36 Fri Nov  4 16:42:06 PDT 2022
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details:
<http://www.gnu.org/licenses/gpl.txt>