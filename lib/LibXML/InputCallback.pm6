use v6;

unit class LibXML::InputCallback;

my class CallbackGroup {
    has &.match is required;
    has &.open  is required;
    has &.read  is required;
    has &.close is required;
    has Str $.trace;
}

my class Context {
    use NativeCall;

    has CallbackGroup $.cb is required;

    my class Handle {
        has Pointer $.addr;
        method addr { with self { $!addr } else { 0 } }
        has $.fh is rw;
        has Blob $.buf is rw;
        sub malloc(size_t --> Pointer) is native {*}
        sub free(Pointer:D) is native {*}
        submethod TWEAK   { $!addr = malloc(1); }
        submethod DESTROY { free($_) with $!addr }
    }
    has Handle %.handles{UInt};

    sub memcpy(CArray[uint8], CArray[uint8], size_t --> CArray[uint8]) is native {*}

    method match {
        -> Str:D $file --> Int {
            CATCH { default { warn $_; return False; } }
            my $rv := + $!cb.match.($file).so;
            note "$_: match $file --> $rv" with $!cb.trace;
            $rv;
        }
    }

    method open {
        -> Str:D $file --> Pointer {
            CATCH { default { warn $_; return Pointer; } }
            my $fh = $!cb.open.($file);
            with $fh {
                my Handle $handle .= new: :$fh;
                %!handles{+$handle.addr} = $handle;
                note "$_: open $file --> {+$handle.addr}" with $!cb.trace;
                $handle.addr;
            }
            else {
                note "$_: open $file --> 0" with $!cb.trace;
                Pointer;
            }
        }
    }

    method read {
        -> Pointer $addr, CArray $out-arr, UInt $bytes --> Int {
            CATCH { default { warn $_; return Pointer; } }
            my Handle $handle = %!handles{+$addr}
                // die "read on unknown handle";
            with $handle.buf // $!cb.read.($handle.fh, $bytes) -> Blob $io-buf {
                my $n-read := $io-buf.bytes;
                if $n-read > $bytes {
                    # read-buffer exceeds output buffer size;
                    # buffer the excess
                    $handle.buf = $io-buf.subbuf($bytes);
                    $io-buf .= subbuf(0, $bytes);
                    $n-read = $bytes;
                }
                else {
                    $handle.buf = Nil;
                }

                note "$_\[{+$addr}\]: read $bytes --> $n-read" with $!cb.trace;
                my CArray[uint8] $io-arr := nativecast(CArray[uint8], $io-buf);
                memcpy($out-arr, $io-arr, $n-read)
                    if $n-read;

                $n-read;
            }
        }
    }

    method close {
        -> Pointer:D $addr --> Int {
            CATCH { default { warn $_; return -1 } }
            note "$_\[{+$addr}\]: close --> 0" with $!cb.trace;
            my Handle $handle = %!handles{+$addr}
                // die (+$addr).fmt("read on unopened input callback context: 0x%X");
            $!cb.close.($handle.fh);
            %!handles{+$addr}:delete;

            0;
        }
    }
}

has CallbackGroup @!callbacks;
method callbacks { @!callbacks }

multi method TWEAK( Hash :callbacks($_)! ) {
    @!callbacks = CallbackGroup.new(|$_)
}
multi method TWEAK( List :callbacks($_)! ) {
    self.register-callbacks: |$_;
}
multi method TWEAK is default {
}

multi method register-callbacks( &match, &open, &read, &close, |c) is default {
    $.register-callbacks( :&match, :&open, :&read, :&close , |c);
}

multi method register-callbacks(*%opts) is default {
    my CallbackGroup $cb .= new: |%opts;
    @!callbacks.push: $cb;
}


multi method unregister-callbacks( :&match, :&open, :&read, :&close ) is default {
    @!callbacks .= grep: {
        (!&match.defined || &match !=== .match)
           && (!&open.defined  || &open  !=== .open)
           && (!&read.defined  || &read  !=== .read)
           && (!&close.defined || &close !=== .close)
    }
}

method append(LibXML::InputCallback $icb) {
    @!callbacks.append: $icb.callbacks;
}

method prepend(LibXML::InputCallback $icb) {
    @!callbacks.prepend: $icb.callbacks;
}

method make-contexts {
    @!callbacks.map: -> $cb { Context.new: :$cb }
}

