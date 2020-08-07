library(sp)
library(rgdal)
library(raster)

#Provide shp or extent of shp
shp = readOGR("/home/Projects/Rcode/districts/Karnataka.shp")
#ext = extent(81.0,90.0,18.0,29.0) #When cropping by extent

#input multiple raster file
ras.files = Sys.glob('/home/Projects/raster/nc/SMN/2020[2-3]*.nc')

#output location
out.dir = '/home/Projects/SMN_karnataka/'


for(ras.file in ras.files)
{ 
  if(file.exists(out.dir)){
    ras <-raster(ras.file)
    ras[ras>1] <- NA    #For modis NDVI 
    datalabel = basename(ras.file)
    crop = crop(ras,shp,snap = "out",na.rm = TRUE) #replace ext in shp when giving extent
    plot(crop, main= datalabel)
    writeRaster(crop,filename = file.path(out.dir,sprintf("%s.tif",substr(datalabel,1,7))),
                overwrite=TRUE)
  }
}
