$pdflatex = 'pdflatex -interaction=nonstopmode %O %S';

sub notify_error {
    my $retcode = $_[0];
    if ($retcode != 0) {
        system("notify-send 'LaTeX Build Failed' 'Check your .log file for details.'");
    }
}
