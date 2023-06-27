﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
	//Элементы.Список.РежимВыбора = Параметры.РежимВыбора;
	//ОперБлокВключен = Истина;
	//Элементы.Подснятия.Видимость = ОперБлокВключен;
	//Если Не ОперБлокВключен Тогда
	//	Элементы.Группа1.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Список1ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ТекФорма = ПолучитьФорму("Документ.УЧ_Инвентаризация.ФормаОбъекта"); 	
		ТекФорма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризация.Подснятие");
		ТекФорма.Открыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если НЕ Копирование Тогда
		Отказ = Истина;
		ТекФорма = ПолучитьФорму("Документ.УЧ_Инвентаризация.ФормаОбъекта"); 	
		ТекФорма.Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийИнвентаризация.Инвентаризация");
		ТекФорма.Открыть();
	КонецЕсли;
КонецПроцедуры
