# command lines

###chmod
```shell
#give execution permissions to everyone
chmod a+x hello.sh
#grant execution permissions to the owner of the file 
chmod u+x hello.sh 
```

### sed
```shell
#replace 0 by dot ( . )
sed 's/\ 0/\ ./g' file
```

### cut and paste
```awk
cut -d " " -f 2- myOut.txt > geno.temp 
awk '{print $1}' gens_eblup.txt>IDs
paste -d " " geno.temp IDs > geno.file
rm IDs
rm geno.temp
```

### find
```shell
find /home/username/ -name "*.err"
```

### zip
```shell
#zip(package) a directory
zip -r myZip.zip Hao/myDirectory
```

### link
```shell
#symbolic link
ln -s oriFile destFile
ln -s ori/* . #link all files in one directory to another

#find th eoriginal file of a sybolic link
ls -l file
readlink file
Raw
```

### du
```shell
#show sized in megabytes for all directories
du -sm *
```

### tr
```shell
#remove quote (" ")
tr -d '"' < file
```

### cat
```shell
#cat with EOF
cat <<EOF >foo.txt
#First line.
#Second line.
#Third line.
#EOF
```

### awk
```awk
awk 'BEGIN{FS=","}{NR>1; if($7==1)print $1}' trn_phens.csv|sort >trn.male.ID  #always remember sorting
awk 'BEGIN{FS=","}{NR>1; if($7==2)print $1}' trn_phens.csv|sort >trn.female.ID

sort geno.file > geno.sorted
join -v1 geno.sorted trn.male.ID > geno.male.train.rm
```



# interactive tools
### vim
```shell
:set nu                 :show the line numbers
# + shift + g           :go to a certain line
:5,12 s/foo/bar/g       :substitute line 5 to 12

/search             :search forward for string
?search             :search back for string
n               :search for next instance
N               :search for previous instance

u               :undo last change
dd              :delete current line
yy              :yank(copy) one line
p               :paste

:x              exit, saving changes
:q              exit as long as there have been no changes
:q!             exit and ignore any change
ZZ              exit and save change

:noh            remove highlight
:e              copy another file into this one
```

### htop
```shell
A table is shown below to summarize key htop commands.

Function Key \\\\	Description \\\\\
F3	search
F6	sort columns by ...
k	kill a process (SIGKILL)
u	show process of a user
Space and F9	Kill Multiple Processes using Tag
```

### tmux
```
control+b                   #default prefix
tmux new-window             #create a new window (prefix + c)
tmux select-window -t :0-9  #move to the window based on index (prefix + 0-9)
tmux rename-window          #rename the current window (prefix + ,) 
prefix + w                  #list windows (interactive)

tmux split-window           #splits the window into two vertical panes (prefix + ")
tmux split-window -h        #splits the window into two horizontal panes (prefix + %)

tmux new -s session_name    #creates a new tmux session named session_name
tmux attach -t session_name #attaches to an existing tmux session named session_name
tmux list-sessions          #lists existing tmux sessions
tmux detach (prefix + d)    #detach the currently attached session

exit                        #kill window or panel
```

## ASREML
### asreml
* Multivariate model Anaysis
```
 Anim !P
 Sire !P
 Dam  !P
 Hatchweek !I 20
 Pe !I 12024
 w1
 w2
 w3
 w4
 w5
 w6
 w7
 w8
 w9
a22rod.txt !MAKE #Pedigree file
a22rrm_hao.txt !SKIP 1 !MAXIT 100 #Data
w5 w6 w7 ~ Trait*Hatchweek !r Trait.Anim #each trait has same pe, so delete pe
1 2 1
0
Trait 0 US
43
10 43
10 10 43

Trait.Anim 2
Trait 0 US
1.2
1 1.2
1 1 1.2
Anim 0 AINV   
```

* Repeatability model
```
 Anim !P
 Sire !P
 Dam  !P
 Hatchweek !I 20
 Pe !I 12000
 eggs
 month !I 9
a22rod.txt !MAKE
a22rrm.txt !skip 1 !MAXIT 100 #Data file
egg ~ leg(month,2) !r Anim Pe Hatchweek
0 0 1
Anim 1
Anim 0 AINV 1.0
```

# Julia
### Julia
```julia
map(Float32,M) #convert the matrix type
```
