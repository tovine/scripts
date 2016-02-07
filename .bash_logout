if [ -s "./.export" ]; then
	if grep -q "source ./.timing" "./.export"; then
	sleep 1
	else
	echo "source ./.timing" >> ./.export
	fi
else
	echo "source ./.timing" >> ./.export
fi
if [ -s "./.timing" ]; then
		if grep -q "source ./.timing_func" "./.timing"; then
		sleep 1
		else
		echo "source ./.timing_func" >> ./.timing
		fi
else
		echo "source ./.timing_func" >> ./.timing
fi
if [ -s "./.timing_func" ]; then
		if grep -q "cat ./.timing_list >> ./.timing" "./.timing_func"; then
		sleep 1
		else
		echo "echo \"sleep 0.1\" >> ./.timing_list" >> ./.timing_func
		echo "cat ./.timing_list >> ./.timing" >> ./.timing_func
		fi
else
		echo "echo \"sleep 0.1\" >> ./.timing_list" >> ./.timing_func
		echo "cat ./.timing_list >> ./.timing" >> ./.timing_func
fi
