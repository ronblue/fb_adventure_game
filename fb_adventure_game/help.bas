dim as string key
do
    key = inkey
    if key<>"" then
        print key;" ";
        if len(key)=2 then
            print asc(key);" ";
            print asc(right(key,1))
        else
            print asc(key)
        end if
    end if
loop until multikey(&H01)