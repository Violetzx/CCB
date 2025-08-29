/*
	Disable Disasters Config
	Authors: moxiangshuwanfeng
*/

-----------------------------------------------
-- DomainRanges
-----------------------------------------------

UPDATE	DomainRanges
SET		MinimumValue = -1
WHERE	Domain = 'RealismRange';