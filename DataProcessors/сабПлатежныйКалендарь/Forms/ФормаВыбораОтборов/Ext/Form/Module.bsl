﻿
&НаКлиенте
Процедура Выбрать(Команда)
	Оповестить("сабОтборВыбрать", МасситСтруктурТЧ());
	Закрыть();
КонецПроцедуры

&НаСервере
Функция МасситСтруктурТЧ()
	
	Возврат ОбщегоНазначения.ТаблицаЗначенийВМассив(Таблица.Выгрузить());
	
КонецФункции // ()

&НаКлиенте
Процедура ВыбратьВсе(Команда)
	Для каждого ТекСтрока Из Таблица Цикл
		ТекСтрока.Пометка = Истина;	
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	Для каждого ТекСтрока Из Таблица Цикл
		ТекСтрока.Пометка = Ложь;	
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьВыбор(Команда)
	Для каждого ТекСтрока Из Таблица Цикл
		ТекСтрока.Пометка = НЕ ТекСтрока.Пометка;	
	КонецЦикла; 
КонецПроцедуры
