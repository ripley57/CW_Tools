
# Description:
#   Pre-save the paths to the various cache directories.
#
# Usage:
#   presavecachedirs
#
function presavecachedirs() {
    if [ "$1" = '-h' ]; then
        usage presavecachedirs
        return
    fi

    local _cwdir="$(cwdir)"
    local _cwver=
    case "$_cwdir" in
    *66*)  _cwver=V66  ;;
    *711*) _cwver=V711 ;;
    *712*) _cwver=V712 ;; 
    *713*) _cwver=V713 ;; 
    *714*) _cwver=V714 ;; 
    *715*) _cwver=V715 ;; 
    *811*) _cwver=V811 ;; 
	*81*)  _cwver=V81  ;;
    esac

    local _esadb_dirname=$(_get_esadb_dirname)

    if [ "$_cwver" = "V66"  -o "$_cwver" = "V711" -o "$_cwver" = "V712" -o \
	     "$_cwver" = "V713" -o "$_cwver" = "V714" -o "$_cwver" = "V715" -o \
		 "$_cwver" = "V81"  -o "$_cwver" = "V811" ]
    then
        presavedir 6 "/cygdrive/d/CW/$_cwver/scratch/temp/$_esadb_dirname"    "__TEMP (AttHTMLCache, OCRFileCache, attCacheDir)_"
        presavedir 7 "/cygdrive/d/CW/$_cwver/scratch/exttemp/$_esadb_dirname" "__EXT_TEMP (NetitDocAttLdr, NetitDocBodyLdr)_____"
        presavedir 8 "/cygdrive/d/CW/$_cwver/extdata/$_esadb_dirname"         "__EXT_DATA (NetITAttFS)__________________________"
        presavedir 9 "/cygdrive/d/CW/$_cwver/data/$_esadb_dirname"            "__DATA (statusLog, ImportXMLs, Lucene, Exports)__"
    fi
}
#presavecachedirs
