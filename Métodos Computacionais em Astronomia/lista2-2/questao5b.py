from astropy.coordinates import get_moon
from astropy.time import Time
now = Time.now()
lua = get_moon(now)
print("\nPosicao da Lua ", lua)