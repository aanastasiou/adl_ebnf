#Athanasios Anastasiou
#Retrieves the TODO lines from source code files
egrep -n "TODO:" `find|egrep "(\.txt)|(\.g4)"`|sed "s/[ \s \t]*//"|sed "s/[ ]*%//"|sed "s/[ ]*\/\///"|sed "s/\(.* \)\(LOW\),*\( .*\)/\2\1\3/"|sed "s/\(.* \)\(HIGH\),*\( .*\)/\2\1\3/"|sed "s/\(.* \)\(MID\),*\( .*\)/\2\1\3/"|sort>list_TODO`date +%d%m%y_%H%M%S`.txt
