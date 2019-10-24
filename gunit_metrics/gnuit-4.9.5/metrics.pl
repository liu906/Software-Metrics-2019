use Understand;

$name = "gnuit-4.9.5.udb";
$db = Understand::open($name);
foreach $func ($db->ents("Function ~undefined ~unknown")){
    print $func->name(),",",
          $func->freetext(Location),",",
          $func->metric("CountLineCode"),",",
          $func->metric("CountPath"),",",
          $func->metric("Cyclomatic"),",",
          $func->metric("MaxNesting"),",",
          $func->metric("Knots"),",",
          $func->metric("CountInput"),",",
          $func->metric("CountOutput"),"\n";
}

$db->close();