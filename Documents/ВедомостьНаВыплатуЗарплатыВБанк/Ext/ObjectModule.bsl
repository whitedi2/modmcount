﻿&После("ПередЗаписью")
Процедура УУ_ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если Модифицированность() И ТипЗнч(ЭтотОбъект) = Тип("ДокументОбъект.ВедомостьНаВыплатуЗарплатыВБанк") Тогда
		сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);	
	КонецЕсли;
КонецПроцедуры
