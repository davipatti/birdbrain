clean:
	rm -f downloads/*

small:
	# This species only has very few records
	# Useful for testing
	search-xeno-canto.py --download --query "spermophaga poliogenys"

common:
	get_common.sh

convert-split:
	./src/mpeg-to-wav.sh
	./src/split-wav.sh
