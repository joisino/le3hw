import sys
from PIL import Image

if( len(sys.argv) != 2 ):
    print( "Usage: %s memfile" % sys.argv[0] )
    exit(1)

print( "height: ", end = "" )
n = int( input() )
print( "width: ", end = "" )
m = int( input() )

img = Image.new( "RGB", (m,n) )

f = open( sys.argv[1], 'rt' )
cnt = 0
for buf in f:
    if( int(buf) == 1 ):
        img.putpixel( (cnt%m,cnt//m), (0,0,0) )
    else:
        img.putpixel( (cnt%m,cnt//m), (255,255,255) )
    cnt += 1
    if( cnt == n * m ):
        break

img.save( "out.png" )
    
