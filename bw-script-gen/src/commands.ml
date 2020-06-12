let get_unused_uid =
  {|getent passwd | awk -F: '($3>600) && ($3<10000) && ($3>maxuid) { maxuid=$3; } END { print maxuid+1; }'|}

let get_unused_gid =
  {|getent passwd | awk -F: '($4>600) && ($4<10000) && ($4>maxgid) { maxgid=$4; } END { print maxgid+1; }'|}
