# Samuel Rivera

from PIL import Image
import glob
import os

outDir= '../CenteredImg/'
if not os.path.exists( outDir):
	os.mkdir( outDir) 

imgs = glob.glob( '../*.bmp')

for img in imgs:
	fg = Image.open( img)
	bg = Image.new( 'RGB', (1920,1080), (255,255,255))
	# get image sizes
	(w, h) = fg.size
	(wB, hB) = bg.size

	# center and save
	bg.paste(fg, (wB/2-w/2,hB/2-h/2))
	bg.save( outDir + img.split( '/')[-1] )

#bg.show()
