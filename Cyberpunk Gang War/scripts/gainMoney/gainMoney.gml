function gainMoney(income)
{
	var adjustedIncome = income //In the future we can modify income by various variables
	
	if boss != noone { //Boss taxes income
		with boss
		{
			gainMoney(taxRate * adjustedIncome)
		}
		adjustedIncome = adjustedIncome - (taxRate * adjustedIncome)//Subtract the taxed income
	}
	else if owner != noone {  //Gang taxes income
		with owner
		{
			gainMoney(taxRate * adjustedIncome)
		}
		adjustedIncome = adjustedIncome - (taxRate * adjustedIncome)//Subtract the taxed income
	}
	money = money + adjustedIncome
}
