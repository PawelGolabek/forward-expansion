/// @description How to cleanup

// You should call .cleanup() before de-referencing to avoid memory leaks
my_crt.cleanup()
delete my_crt;
