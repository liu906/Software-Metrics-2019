use feature qw(say);
use Understand;

$db = Understand::open("bash-4.2.udb");
%tag = ();
@files = glob("patches/bash42-???");



foreach $patchfile (@files) {


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

                    if( $func->ref("Define")->line() > $lineNum ){

                        if(exists($tag{$lastFunc}))
                        {
                            $tag{$lastFunc} += 1;
                            
                        }
                        else{
                            $tag{$lastFunc} = 1;
                            
                        }

                        last;
                    }
                    $lastFunc= $func->name();

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