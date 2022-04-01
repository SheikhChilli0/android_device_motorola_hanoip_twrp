#!/system/bin/sh


touch_class_path=/sys/class/touchscreen
touch_path=
firmware_path=/vendor/firmware
firmware_file=
wait_for_poweron()
{
	local wait_nomore
	local readiness
	local count
	wait_nomore=60
	count=0
	while true; do
		readiness=$(cat $touch_path/poweron)
		if [ "$readiness" == "1" ]; then
			break;
		fi
		count=$((count+1))
		[ $count -eq $wait_nomore ] && break
		sleep 1
	done
	if [ $count -eq $wait_nomore ]; then
		return 1
	fi
	return 0
}
fstab_fixup()
{
	sed -i "s|keydirectory=/metadata/vold/metadata_encryption,quota,reservedsize=512M|quota,reservedsize=128M|" /system/etc/recovery.fstab
}


cd $firmware_path
touch_product_string=$(ls $touch_class_path)
echo "ilitek"
firmware_file="FW_ILITEK_TDDI_TM.bin"
touch_path=/sys$(cat $touch_class_path/$touch_product_string/path | awk '{print $1}')
wait_for_poweron
fstab_fixup

echo $firmware_file > $touch_path/doreflash
echo 1 > $touch_path/forcereflash
sleep 5
echo 1 > $touch_path/reset

return 0
