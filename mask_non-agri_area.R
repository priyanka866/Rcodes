library(sp)
library(rgdal)
library(raster)

shp = readOGR("input vector file")
ras.files = Sys.glob('path to files/2010*.nc')
out.dir =  "/home/satyukt/Projects/1000/backend/Noostar_ndvi/SMN_karnataka/agrimasked_liss"
udaviR::ensureDir(out.dir)
lulc <- "liss lulc" # liss lulc 
#for modis add get_subdatasets with band index
r.lulc = get_subdatasets(lulc)
lulc.type1 = r.lulc[1]

ras.lulc = raster(lulc)
crs <- '+proj=longlat +datum=WGS84 +no_defs'

#croping raster 
for(ras.file in ras.files)
{ 
  if(file.exists(out.dir)){
    ras <-raster(ras.file)
    ras[ras>1] <- NA    #For modis NDVI    
    datalabel = basename(ras.file)
    crop = crop(ras,shp,snap = "out",na.rm = TRUE) 
#masking non-agricultural area
    crs.lulc <- projectRaster(ras.lulc,crop,crs = crs, method = 'ngb')
    crop[crs.lulc != 2 & crs.lulc != 7] = NA # liss data for modis use 12 & 14
    plot(crop, main= datalabel) 
    writeRaster(crop, file.path(out.dir,sprintf("%s.tif",substr(datalabel, 1,7))),overwrite=T)
  }
}