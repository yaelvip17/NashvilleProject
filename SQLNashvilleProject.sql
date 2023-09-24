-- Standardize Date Format

ALTER TABLE NashvilleHousing
Add updateSaleDate Date;

-- select the above and press f5 (execute)

Update NashvilleHousing
SET updateSaleDate = CONVERT(Date,SaleDate)

-- select the above and press f5 (execute)

-- Populate Property Address data

Select v1.ParcelID, v1.PropertyAddress, v2.ParcelID, v2.PropertyAddress,
ISNULL(v1.PropertyAddress,v2.PropertyAddress)
From NashvilleHousing v1
JOIN NashvilleHousing v2
	on v1.ParcelID = v2.ParcelID
	AND v1.[UniqueID ] <> v2.[UniqueID ]
Where v1.PropertyAddress is null

Update v1
SET PropertyAddress = ISNULL(v1.PropertyAddress,v2.PropertyAddress)
From NashvilleHousing v1
JOIN NashvilleHousing v2
	on v1.ParcelID = v2.ParcelID
	AND v1.[UniqueID ] <> v2.[UniqueID ]
Where v1.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

ALTER TABLE NashvilleHousing
Add address Nvarchar(255);

-- select the above and press f5 (execute)

Update NashvilleHousing
SET address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

-- select the above and press f5 (execute)

ALTER TABLE NashvilleHousing
Add city Nvarchar(255);

-- select the above and press f5 (execute)

Update NashvilleHousing
SET city = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1,
LEN(PropertyAddress))

-- select the above and press f5 (execute)

ALTER TABLE NashvilleHousing
Add ownerAddress Nvarchar(255);

-- select the above and press f5 (execute)

Update NashvilleHousing
SET ownerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

-- select the above and press f5 (execute)

ALTER TABLE NashvilleHousing
Add ownerCity Nvarchar(255);

-- select the above and press f5 (execute)

Update NashvilleHousing
SET ownerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

-- select the above and press f5 (execute)

ALTER TABLE NashvilleHousing
Add ownerState Nvarchar(255);

-- select the above and press f5 (execute)

Update NashvilleHousing
SET ownerState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

-- select the above and press f5 (execute)

-- matching the values at SoldAsVacant option 1
-- changing the "N"+"Y" to "no"+"yes"

select SoldAsVacant,
case
when SoldAsVacant='N' then 'No'
when SoldAsVacant='Y' then 'Yes'
else SoldAsVacant
end
from NashvilleHousing

-- matching the values at SoldAsVacant option 2
-- changing the "N"+"Y" to "no"+"yes"

--update NashvilleHousing
--set SoldAsVacant=case
--when SoldAsVacant='N' then 'No'
--when SoldAsVacant='Y' then 'Yes'
--else SoldAsVacant
--end

-- deleting duplicates

with duplicates as
(select *, ROW_NUMBER() over (partition by ParcelID, PropertyAddress, SalePrice,
SaleDate, LegalReference ORDER BY UniqueID) row_num
From NashvilleHousing
)

delete
From duplicates
Where row_num > 1

-- dropping unused columms
-- deleting the duplicate columms

alter table NashvilleHousing
drop column OwnerAddress, PropertyAddress, SaleDate, TaxDistrict
