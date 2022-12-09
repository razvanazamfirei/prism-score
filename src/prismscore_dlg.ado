local realdir : sysdir `"PERSONAL"'
	cd "`realdir'"
		file open profile using profile.do, write text append
			file write profile `"window menu append item "stUserData" "PRISM Score" "db prismscore""'
		file close profile
	window menu refresh
cd
