SELECT * 
from [Portfolio Project]..heart$
order by 3,4






---general grouping for resting BP over 80. 

Select age, sex, restingbp, heartdisease
from [Portfolio Project]..heart$
where  RestingBP > 80
and HeartDisease != 0
order by sex, Age



--Male population with heart disease with resting BP over 100

Select age, sex, restingbp, heartdisease
from [Portfolio Project]..heart$
where sex = 'M' and RestingBP >100 and HeartDisease != 0 and age < 45
order by Age 


--Cholesterol levels between ages, exercise induced angina, and heart diesase (Men)

select *
from [Portfolio Project]..heart$
where Cholesterol < 200
and RestingBP > 90
and HeartDisease != 0
and sex = 'M'
order by Age


--Cholesterol levels between ages, exercise induced angina, and heart diesase (Women)

select *
from [Portfolio Project]..heart$
where Cholesterol < 200
and RestingBP > 90
and HeartDisease != 0
and sex = 'F'
order by Age



--joining male and female Cholesterol results by age and bp

select age, restingbp, heartdisease
from [Portfolio Project]..heart$ male
join [Portfolio Project]..heart$_xlnm#_FilterDatabase female
on male.sex = female.sex
where Cholesterol < 200
and RestingBP > 100
order by age


with male as (
select sex, ChestPainType , MaxHR, ExerciseAngina, heartdisease
from [Portfolio Project]..heart$
where Oldpeak > 1.5
and HeartDisease = 1
and ChestPainType like ('%ATA%')
and RestingBP >100
and sex = 'M'
),
female as (
select sex, ChestPainType , MaxHR, ExerciseAngina, heartdisease
from [Portfolio Project]..heart$
where Oldpeak > 1.5
and HeartDisease = 1
and ChestPainType like ('%ATA%')
and RestingBP >100
and sex = 'F'
)


select *
from male
join female 
on male.sex=female.sex
ORDER by AGE

---Women at Risk for Heart Issues
select
count(sex) as Women_at_Risk
FROM [Portfolio Project]..heart$
where sex = 'F'
and RestingBP > 100
and ChestPainType LIKE '%ASY%'
AND ExerciseAngina = 'y'
and Age > 35

---Men at risk for Heart Issues
Select
count(sex) as Men_at_Risk
from [Portfolio Project]..heart$
where sex = 'M'
and RestingBP > 100
and ChestPainType like '%ASY%'
AND ExerciseAngina = 'Y'
and Age > 35

