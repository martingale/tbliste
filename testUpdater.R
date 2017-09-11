setwd("bondProject/tbliste/")
library("stringdist")
library("xlsx")

tmp <- read.xlsx("tbliste.xls",sheetIndex = 1)
tmp <- (tmp[!is.na(tmp[,1]),])
head(tmp)

tmp[tmp[,2]=="TRFTHAL21814",]
tmp[tmp[,2]=="TRFTISB21815",]
tmp[tmp[,2]=="TRFTISB41813",]

library(RODBC)
library(zoo)
dbhandle <- odbcDriverConnect('dsn=BONDDB;Database=OSMANLIBOND;UID=osmanlibond_usr;PWD=osmanlibond1*')
grep("yiel",sqlTables(dbhandle)[,3],ignore.case = T)
sqlTables(dbhandle)
bondDef <- sqlQuery(dbhandle,"Select * from BONDDEFINITION")
IssuerTab <- sqlQuery(dbhandle,"Select * from ISSUERS")
currencyTab <- sqlQuery(dbhandle,"Select * from CURRENCIES")
paymentTab <- sqlQuery(dbhandle,"Select * from BONDPAYMENTTYPE")
dayContTab <- sqlQuery(dbhandle,"Select * from DAYCOUNTCONVENTION")
bondCatTab <- sqlQuery(dbhandle,"Select * from tblBondCategory")
yieldTab <- sqlQuery(dbhandle,"Select * from YIELDTYPE")
names(bondDef)
head(bondDef)

ISINs <- c("TRFTHAL21814","TRFTISB21815","TRFTISB41813")
sqlQuery(dbhandle,"Select * from BONDDEFINITION WHERE ISIN = 'TRFTISB21815'")
x <- 2
newBond <- tmp[tmp[,2]==ISINs[x],]
issuer <- IssuerTab[amatch("işbankası",as.character(IssuerTab$NAME),maxDist = 100,method = "lcs"),1]
currency <- currencyTab[as.character(currencyTab[,2])==newBond$Para.Birimi.Currency,1]

newBond$Getiri.Türü.Type.of.I
yieldTab
payType <- yieldType <- 0


newBond$Gün.Sayım.Konvansiyonu.Day.Count.Convention
dayContTab
dayCountConv <- 4

newBond$İhraçcı.Kurum.Issuer
bondCatTab
bondCate <- 3

df <- data.frame(ISIN = as.character(newBond$ISIN.Kodu.ISIN.Code),
                 TYPECODE = newBond$Grup.Kodu.Group.Code,
                 ISSUER= issuer,
                 CURRENCY=currency,
                 ISSUEDATE = as.Date(as.numeric(as.character(newBond$Son.İhraç.Tarihi.Last.Issue.date)),origin = "1899-12-30"),
                 MATURITY = newBond$İtfa.Tarihi.Maturity.Date,
                 COUPONFREQ = ifelse(is.null(newBond$yıYıllık.Kupon.Sayısı.Number.of.Coupons.p.a.),0,newBond$yıYıllık.Kupon.Sayısı.Number.of.Coupons.p.a.),
                 COUPONRATE = as.numeric(as.character(newBond$Sonraki.Kupon.Oranı...Next.Coupon.Rate..)),
                 SPREAD = na.fill(as.numeric(as.character(newBond$Ek.Getiri.........Spread........)),0),
                 TOTALISSUEDAMOUNT= newBond$Toplam.İhraç.Tutarı.Nom..Total.Issue.Amount.Nom...1000.TRY.USD.EUR.,
                 LRATING=NA,
                 PAYMENTTYPE=payType,
                 YIELDTYPE=yieldType,
                 NEXTCOUPONDATE = as.Date(as.numeric(as.character(newBond$Sonraki.Kupon.Tarihi.Next.Coupon.Date)),origin = "1899-12-30"),
                 DAYCOUNTCONVENTION=dayCountConv,
                 BondStatusId=1,
                 BondCategoryId=bondCate,
                 ISSUANCETYPE = as.character(newBond$İhraç.Türü.Type.of.Issuance),
                 COUPONPERIOD=NA,
                 COUPONPERIODUNIT=NA,
                 QLIBCOUPONRATE=NA,
                 ISCORRUPT=0
                 )
# head(bondDef)
df

# RODBC::sqlSave(dbhandle,df,"BONDDEFINITION", verbose=T, append=T,safer = T, test = F,rownames=FALSE, fast = F)
RODBC::sqlUpdate(dbhandle,df[,-11],"BONDDEFINITION",index = c("ISIN") , verbose=T, fast = F)
