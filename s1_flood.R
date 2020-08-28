library(raster)
library(rgdal)
library(rasterVis)

post <- "C:/Users/priya/Downloads/S1A_IW_GRDH_1SDV_20200410T114822_20200410T114847_032065_03B493_5B22.SAFE/measurement/s1a-iw-grd-vv-20200410t114822-20200410t114847-032065-03b493-001.tiff"
ras <- raster(post)
db <- 10*log10 (ras)
out.dir <- "/C:/Users/priya/Downloads/S1A_IW_GRDH_1SDV_20200410T114822_20200410T114847_032065_03B493_5B22.SAFE/measurement/"

datalable <- basename(post)
out.ras <- ras
out.ras[is.na(out.ras)]<- NA
out.ras[] <- 0
out.ras[ras < 50] <- 1     #threshold
levelplot(out.ras,margin = FALSE, main = "Bihar impacted area",
          col.regions=colorRampPalette(c("white", "blue"))) 
writeRaster(out.ras, file.path(out.dir,sprintf("%s.tif",substr(datalable,18,70))),overwrite = T)
