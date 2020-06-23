awk
{
    gsub(/<\/*trk>/,"",$0)
    gsub(/<\/*trkseg>/,"",$0)
    gsub(/<trkpt/,"<wpt", $0)
    gsub(/<\/trkpt>/,"<\/wpt>", $0)
}
END {}
$1
