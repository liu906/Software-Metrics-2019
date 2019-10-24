use feature qw(say);
use Understand;

$db = Understand::open("bash-4.2.udb");
%tag = ();
@files = glob("patches/bash42-???");

#open( DATA, "<patches/bash42-001" ) or die "patch $file cannot be opened";

foreach $patchfile (@files) {
    #print "====================patch file :$patchfile===============\n";

    open DATA, "<$patchfile" or die "patch files cannot be opened";
    $lineNum = 0;
    $file = 0;
    
    while ( my $line = <DATA> ) {

        # print $line;
        if ( $line =~ /^---\s[0-9]{1,4},[0-9]{1,4}\s----/ ) {
            #print $line;

            $line =~ m/[0-9]{1,4}/;
            $line = $&;
            #print "$&\n";
            $lineNum = $line;
        }
        elsif($line =~ /^\*\*\*\s..\/[^\f\n\r\t\v\*]/){
            #print $line, "\n";
            $line =~ m/\t/;
            $line = $`;
            #print $line, "\n";
            $line =~ m/\//;
            $line = $';
            #print $line, "\n";
            $line =~ m/\//;
            $line = $';
            #print $line, "\n";
            $file = $line;
        }

        if($lineNum && $file){
                  #      print "*********************************************\n",
                  #$lineNum, " ", $file,"\n";
            #print "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n";
            #print "file is $file linenum is $lineNum\n";
            #searchFunc($file,$lineNum);
            $lastFunc = "";

            $ufile = $db->lookup("$file","File");
            if($ufile){
             #print "line number is ",$lineNum,"\n";
             
                @arr = $ufile->ents("Define");
                $i = 0;
                @ents = ();
                while($i<@arr){
                    if(@arr[$i]->ref("Define") && (@arr[$i]->kind()->longname() eq "C Function" || @arr[$i]->kind()->longname() eq "C Function Static" )){
                        push(@ents,@arr[$i]);
                    }
                    $i++;
                }
                
                foreach $func (sort{$a->ref("Define")->line() <=> $b->ref("Define")->line();} @ents){
                    #print "\$func line num is ",$func->ref()->line()," ",$func->name(),"\n";
                    #if(!($func->kind()->longname() eq "C Function" || $func->kind()->longname() eq "C Function Static" )){
                    #    next;
                    #}
                    #print $func->name(),"\n";
                    #print $func->name(),$func->ref()->line(),"  $lineNum + 0.01\n";
                    if( $func->ref("Define")->line() > $lineNum ){
                        #if($lineNum eq "7181"){
                        #    print "*********************************************\n",
                        #    $lineNum, " ", $file," ",$lastFunc,"\n";
                        #}
                        
                        #print $lastFunc," ",$func->ref()->line()," ",$linenum,"\n";
                        if(exists($tag{$lastFunc}))
                        {
                            $tag{$lastFunc} += 1;
                            
                        }
                        else{
                            $tag{$lastFunc} = 1;
                            
                        }
                        #print "===============================================\n"
                        last;
                    }
                    $lastFunc= $func->name();
                    #print "^^^^^^^^^^^^^^^^^^$lastFunc^^^^^^^^^^^^^^^^^^^^\n"
                }
            }
   
            $lineNum = 0;
            
        }
        
    }
    close DATA;

}

foreach $func ($db->ents("Function ~unresolved ~undefined")){
    if(exists($tag{$func->name()})){
    
    }
    else{
        $tag{$func->name()} = 0;
    }

}
print "$_,$tag{$_}\n" for (keys %tag);