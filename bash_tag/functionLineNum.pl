  use Understand;
  $db = Understand::open("bash-4.2_fuzzy.udb");
  # loop through all functions
  #function ~unresolved ~unknown
  #foreach $func ($db->ents("function")) {
  #  #$path = $func->parent()->relname();
  #  #$path =~ m/\/*.[a-z]{1}/;
  #  
  # 
  # print  $func->ref()->ent()->name()," ",
  #        $func->ref()->line(),"\n";
  #  print "-----------------------------\n"
  #}
  
#foreach $file ($db->ents("file")){
#    $lastFunc = "";
#    foreach $func ($file->ents("Define")){
#        #print "000lastFunc is $lastFunc \n";
#        if($lastFunc ne ""){
#            print $func->name(),",",$lastFunc,"\n";
#        }
#        $lastFunc = $func->name();
#        #print "lastFunc is $lastFunc \n";
#    }
#}


$file = $db->lookup("chk_arithsub","Function");
#$file = $db->lookup("chk_arithsub","Function");

print $file->ib(),"\n";
print $file->kind()->name()," , ",$file->kind()->longname(),"\n";
$file = $db->lookup("subst.c","File");
print "----------------------------------------\n";

@arr = $file->ents("Define");
$i = 0;
@ents = ();
while($i<@arr){
    if(@arr[$i]->ref("Define") && (@arr[$i]->kind()->longname() eq "C Function" || @arr[$i]->kind()->longname() eq "C Function Static" )){
        push(@ents,@arr[$i]);
    }
    $i++;
}
#foreach $ent (@ents){
#    print $ent->name(),"\n";
#}
foreach $ent (sort{$a->ref("Define")->line() <=> $b->ref("Define")->line();} @ents){
    if(!($ent->kind()->longname() eq "C Function" || $ent->kind()->longname() eq "C Function Static" )){
        next;
    }
    print $ent->name(),",",$ent->ref("Define")->line() ,",",$ent->kind()->name(),",",$ent->kind()->longname(),"\n";
}
#foreach $ent ($file->ents("Define")){
#    if(!($ent->kind()->longname() eq "C Function" || $ent->kind()->longname() eq "C Function Static" )){
#        next;
#    }
#    print $ent->name(),",",$ent->ref("Define")->line() ,",",$ent->kind()->name(),",",$ent->kind()->longname(),"\n";
#}