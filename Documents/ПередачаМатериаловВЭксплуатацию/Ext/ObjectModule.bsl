﻿
&Перед("ПередЗаписью")
Процедура УУ_ПередЗаписью1(Отказ, РежимЗаписи, РежимПроведения) 

	Если Модифицированность() Тогда
		Если ДополнительныеСвойства.Свойство("НеДобавлятьЗаписьВРегистрИзмененных") Тогда
			Если Не ДополнительныеСвойства.НеДобавлятьЗаписьВРегистрИзмененных Тогда
				сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
			КонецЕсли;
		Иначе
			сабОбщегоНазначенияБУХ.УстановитьМодифицированностьБУДокумента(ЭтотОбъект, Ссылка, РежимЗаписи);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
