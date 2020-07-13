
## Limitations

1. Drag'n'drop files into iOS Simulator works only from $HOME directory
1. Xcode location simulation works only with waypoints GPX files

## GPX processing

pbpaste > debug.gpx
xmllint --format input.xml > output.xml
awk -f gpx_fix input.gpx > output.gpx
