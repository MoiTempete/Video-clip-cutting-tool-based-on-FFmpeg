#!/bin/bash
flag=true
read -r -t 30 -p "confirm clip size(1-10,second): " input_hls_time
while $flag
do
  expr $input_hls_time + 0 &> /dev/null
  [ $? -eq 0 ] && flag=false || read -r -p "please input a integer:" input_hls_time
done
echo "clip size is: $input_hls_time"
for i in *.mp4
do
  if [ ! -e "$i" ]; then {
      echo "can not find file to convert"
      break
      }
  fi
  echo $i
  echo ${i%.mp4}
  ./ffmpeg -i $i -force_key_frames "expr:gte(t,n_forced*$input_hls_time)" -c:v libx264 -hls_time $input_hls_time -hls_list_size 0 -c:a aac -strict -2 -f hls ${i%.mp4}.m3u8
  rm $i
done

