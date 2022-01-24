select top (1000) [UniqueID ]
from [Portfolio Project]..NashvilleHousing



--1. Intro select (not always practical but fione for smaller data sets)
SELECT *
FROM [Portfolio Project]..NashvilleHousing


--2.  Standardize data format

Select SaleDate, CONVERT(Date,SaleDate)
FROM [Portfolio Project]..NashvilleHousing

Update NashvilleHousing
Set saledate = CONVERT(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set saledate = CONVERT(Date,SaleDate)


-----------------------------------------------------------------

--Populate Property Address data

Select *
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

------------------------------

----Self Join


Select a.ParcelID, a. PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-------------------------------------------
--seperate address into individual columns(address,city,state)


Select PropertyAddress
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID


----Removing a Comma
Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, len(PropertyAddress)) Address
from [Portfolio Project]..NashvilleHousing

Alter Table NashvilleHousing
add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, len(PropertyAddress))

Select *
from [Portfolio Project]..NashvilleHousing




Select OwnerAddress
from [Portfolio Project]..NashvilleHousing

-------------------------------------

---Simpler way to split  address

Select
PARSENAME(replace(OwnerAddress, ',', '.') ,3)
,PARSENAME(replace(OwnerAddress, ',', '.') ,2)
,PARSENAME(replace(OwnerAddress, ',', '.') ,1)
from [Portfolio Project]..NashvilleHousing


Alter Table NashvilleHousing
add OwverSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwverSplitAddress = PARSENAME(replace(OwnerAddress, ',', '.') ,3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',', '.') ,2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',', '.') ,1)



Select *
from [Portfolio Project]..NashvilleHousing


-----------------------------------
--Change y and n to Yes and No in "Sold as Vacant" field


Select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant
,case when SoldAsVacant= 'Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end
from [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
set SoldAsVacant =case when SoldAsVacant= 'Y' then 'Yes'
	when SoldAsVacant='N' then 'No'
	else SoldAsVacant
	end




---Remove Duplicates Using CTE------


With RowNumCTE AS(
Select *,
	ROW_NUMBER()over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by
					UniqueID
					) row_num
				

from [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
SELECT *
from RowNumCTE
where row_num > 1
order by PropertyAddress

Select *
from [Portfolio Project]..NashvilleHousing


---------


--Delete unused columns

 

Alter table[Portfolio Project]..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

Alter table[Portfolio Project]..NashvilleHousing
drop column SaleDate