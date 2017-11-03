#!/bin/awk -f

BEGIN    {
FS="=";
}
/Exec=/{
system($2);
}
