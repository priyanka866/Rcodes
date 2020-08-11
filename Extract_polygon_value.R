t1 <- Sys.time()
library(raster)
library (rgdal)
yyyys <- c(2010:2019)
shp <- readOGR("Path of the shapefile")
in.dir <-'Raster data path' 
out.dir <- "output path"

out.file <- file.path(out.dir, 'file_name.gpkg')
shp.df <- shp@data
n.shpdf <- shp.df[,-c(3:6)] #to remove some unwanted colunm
year =c()

for(yyyy in yyyys){
  if(file.exists(out.dir)){
    ras.files <- Sys.glob(sprintf("%s*.tif", file.path(in.dir, yyyy)))
    r.stack <- stack(ras.files)
    shp.ext <- extract(r.stack, shp, fun=mean, na.rm = T, df=TRUE)
    rnd <- round(shp.ext,3) #rounding it to 3 decimal places
    rm.Id <- rnd[,-1] #removing the unwanted column 
    year <- append (year, rm.Id)
    print(yyyy)
    #break
  }
}

shp@data <- cbind(n.shpdf,year)
out.layername <- gsub('.gpkg',"",basename(out.file))
writeOGR(shp, out.file, out.layername,  driver = "GPKG", overwrite_layer = T)
t2 <- Sys.time()
diff <- t2 - t1