
--STANDARDIZE DATE FORMAT

Select SaleDate
from NashVilleHousing

ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE 


----------------------------------------------------------------


--Populate Property Address Data

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress ,isnull(a.PropertyAddress,b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=isnull(a.PropertyAddress,b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------

--Breaking Out Address Into Individual Columns(Address,City,State)

select PropertyAddress
from NashVilleHousing


select 
substring (PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress) +1,len(PropertyAddress) ) as Address
from NashVilleHousing

alter table NashVilleHousing
Add PropertySplitAddress nvarchar(255)

update NashVilleHousing
set PropertySplitAddress=substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

alter table NashVilleHousing
add PropertySplitCity nvarchar(255)

update NashVilleHousing
set PropertySplitCity=substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress))

select 
Parsename(replace(OwnerAddress,',','.'),3),
Parsename(replace(OwnerAddress,',','.'),2),
Parsename(replace(OwnerAddress,',','.'),1)
from NashVilleHousing


alter table NashVilleHousing
add OwenerSplitAddress nvarchar(255)

update NashVilleHousing
Set OwenerSplitAddress=Parsename(replace(OwnerAddress,',','.'),3)

alter table NashVilleHousing
add OwnersplitCity nvarchar(255)

update NashVilleHousing
set OwnersplitCity=Parsename(replace(OwnerAddress,',','.'),2)

alter table NashVilleHousing
add OwenerSplitState nvarchar(255)

update NashVilleHousing
set NashVilleHousing=Parsename(replace(OwnerAddress,',','.'),1)

exec sp_rename 'NashVilleHousing.OwnersplitCity',OwnerSplitCity

------------------------------------------------------------------------------------
--Replacing Y and N to Yes and No in Sold as Vacant Field

select SoldAsVacant, 
CASE
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
from NashVilleHousing
group by SoldAsVacant

update NashVilleHousing
SET SoldAsVacant=CASE
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end


select Distinct(SoldAsVacant),count(SoldAsvacant)
from NashVilleHousing
group by SoldAsVacant



--Rename Duplicates

with RowNumCTE as(
select*,
ROW_NUMBER() over(
partition by ParcelId,
            PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by UniqueId) row_num

from NashVilleHousing
)
select*
FROM RowNumCTE
	where row_num>1


	-----------------------------------------------------
	--Delete Unused Columns

	select*
	from NashVilleHousing

	alter table NashVilleHousing
	Drop Column LandUse,TaxDistrict,OwnerAddress


	alter table NashVilleHousing
	drop column BedRooms