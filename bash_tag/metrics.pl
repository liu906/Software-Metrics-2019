use Understand;
#use Text::CSV;


#my $csv = Text::CSV->new(
#    filename => "gunit_metrics.csv",
#    fields => [qw/name path CountLineCode CountPath Cyclomatic MaxNesting Knots CountInput CountOutput/]
#);

$name = "bash-4.2.udb";
$db = Understand::open($name);
foreach $func ($db->ents("Function ~undefined ~unknown")){
    #$csv->addline([
          print $func->name(),",",
          $func->parent()->relname(),",",
          $func->metric("CountLineCode"),",",
          $func->metric("CountPath"),",",
          $func->metric("Cyclomatic"),",",
          $func->metric("MaxNesting"),",",
          $func->metric("Knots"),",",
          $func->metric("CountInput"),",",
          $func->metric("CountOutput"),"\n";
          # ])
}

$db->close();