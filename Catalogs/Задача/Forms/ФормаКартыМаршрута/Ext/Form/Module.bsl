﻿&НаСервере
Процедура ОбновитьКартуМаршрута()
	Если ЗначениеЗаполнено(БизнесПроцесс) Тогда
		КартаМаршрута = БизнесПроцесс.ПолучитьОбъект().ПолучитьКартуМаршрута();
	ИначеЕсли БизнесПроцесс <> Неопределено Тогда
		КартаМаршрута = Справочники[БизнесПроцесс.Метаданные().Имя].ПолучитьКартуМаршрута();
	Иначе
		КартаМаршрута = Новый ГрафическаяСхема;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокЗадачТочкиМаршрута()

#Если ВебКлиент Или МобильныйКлиент Или МобильноеПриложениеКлиент Тогда
	Предупреждение("В Веб-клиенте данная операция недоступна.");
	Возврат;
#КонецЕсли
	ОчиститьСообщения();
	ТекЭлемент = Элементы.КартаМаршрута.ТекущийЭлемент;

	Если Не ЗначениеЗаполнено(БизнесПроцесс) Тогда
		Предупреждение("Необходимо указать бизнес-процесс.");
		Возврат;
	КонецЕсли;
	
	Если ТекЭлемент = Неопределено ИЛИ
		НЕ (ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыДействие")
		ИЛИ ТипЗнч(ТекЭлемент) = Тип("ЭлементГрафическойСхемыВложенныйБизнесПроцесс")) Тогда
		
		Предупреждение("Необходимо выбрать точку действия или вложенный бизнес-процесс карты маршрута.");
		Возврат;
	КонецЕсли;

	ЗаголовокФормы = "Справочники по точке маршрута " + Строка(ТекЭлемент.Значение) + " бизнес-процесса " + Строка(БизнесПроцесс);
	ОткрытьФорму("Справочник.Задача.Форма.СписокМоихЗадач", 
		Новый Структура("Отбор,ЗаголовокФормы", 
			Новый Структура("БизнесПроцесс,ТочкаМаршрута", БизнесПроцесс, ТекЭлемент.Значение),
			ЗаголовокФормы),
		ЭтаФорма, БизнесПроцесс);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ТипЗнч(Параметры.Задача) = Тип("ЗадачаСсылка.Задача") Тогда
		БизнесПроцесс = Параметры.Задача.БизнесПроцесс;
	Иначе
		БизнесПроцесс = Неопределено;	
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	ОбновитьКартуМаршрута();   
КонецПроцедуры

&НаКлиенте
Процедура БизнесПроцессПриИзменении(Элемент)
	ОбновитьКартуМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура СправочникиВыполнить()
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрутаВыбор(Элемент)
	ОткрытьСписокЗадачТочкиМаршрута();
КонецПроцедуры


