png(here::here("fig2/fig.png"))

plot(mtcars$disp, mtcars$mpg)
abline(lm(mpg~disp, data=mtcars),col="red")

dev.off()