import re, itertools, sys

# let's do this just once, not at every call
_clean_control_chars = "".join(
    map(chr, itertools.chain(range(0x00, 0x20), range(0x7F, 0xA0)))
)
_clean_control_char_re = re.compile("[%s]" % re.escape(_clean_control_chars))


def cleanup_str(s):
    return _clean_control_char_re.sub("", s)


def print_err(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)
