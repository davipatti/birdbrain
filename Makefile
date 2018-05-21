small:
	# Spermophaga poliogenys only has very few records
	# Useful for testing
	./src/search-xeno-canto.py --download --query "spermophaga poliogenys"

common:
	./src/download.sh common.txt

convert-split:
	./src/mpeg-to-wav.sh
	./src/split-wav.sh
