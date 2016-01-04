RELEASE_CFLAGS=-Dstricmp=strcasecmp -O3 -ffast-math -funroll-loops -fomit-frame-pointer -fexpensive-optimizations

DEBUG_CFLAGS=-Dstricmp=strcasecmp -g

CFLAGS=$(RELEASE_CFLAGS)

DR_FLAGS=-DGLQUAKE -D_DLL_BUILD -shared

renderers=build/dr_default.so build/brush.so build/bprint.so build/sketch.so

all_renderers=$(renderers) build/ainpr.so

release:
	make all CFLAGS="$(RELEASE_CFLAGS)"

debug:
	make all CFLAGS="$(DEBUG_CFLAGS)"

all: quake dynamic_renderers

quake:
	make -C NPRQuakeSrc CFLAGS="$(CFLAGS)"

dynamic_renderers: $(all_renderers)

build/ainpr.so: dynamic_r/ainpr.c dynamic_r/*.h
	gcc $(CFLAGS) $(DR_FLAGS) -lGLU -o build/ainpr.so dynamic_r/ainpr.c

$(renderers): build/%.so: dynamic_r/%.c dynamic_r/*.h
	gcc $(CFLAGS) $(DR_FLAGS) -o $@ $<

clean:
	make -C NPRQuakeSrc clean
