## Constant Product Automated Market Maker Proof of Concept Smart Contract

This project was created in order to better understand how a constant product automated market maker (AMM) smart contract works. This is an over simplified AMM exchange contract was created to better understand how the constant product formula works in practice. 

## Constant Product Function

This swap contract uses the formula:  
$$ {x * y = k} $$ 

where x is the amount of token x  
where y is the amount of token y  
and k is a constant  

## Calculating change in x from change in y:

From:  
$$ {x * y = k} $$  
We can deduce:  
$$  {k = (x+dx) * (y+dy)} $$  

After removing the constants x, y, and k we arrive at the following:
$$ {dy = \frac{(-dx * 1)} {(dx + 1)}} $$




## Lets say that we have the following scenario:

amount of tokens X in the contract = 5  
amount of tokens Y in the contract = 10  

A user comes along and they want to give us 1 of token X in exchange for token Y.

Following the formula constant product formula (x * y = k), we need to calculate the change of Y given a change in X.  

```
x = 5
y = 10
k = 50
dx = 1 

k = (x+1) * (y+dy)

50 = (5+1) * (10+dy)
50 = 6 * (10 + dy)
50 = 60 + 6dy
-10 = 6dy
-10/6 = dy
-1.666 = dy


amountOut = (-dx * y) / (dx + x)
```

## Constant Product Function given x = 5, y = 10, dx = 1

<p align="center">
   <img src="./doc/curve.png">
</p>