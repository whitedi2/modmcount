﻿
&НаСервере
Процедура ЗаполнитьПоАссортиментуНаСервере()

	Объект.Товары.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НоменклатураПоставщикаСрезПоследних.Номенклатура
	|ИЗ
	|	РегистрСведений.НоменклатураПоставщика.СрезПоследних(
	|			&Период,
	|			Предприятие = &Предприятие
	|				И Подразделение В ИЕРАРХИИ (&Подразделения)
	|				И Контрагент = &Контрагент) КАК НоменклатураПоставщикаСрезПоследних
	|
	|СГРУППИРОВАТЬ ПО
	|	НоменклатураПоставщикаСрезПоследних.Номенклатура";
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("Предприятие", Объект.Предприятие);
	Запрос.УстановитьПараметр("Подразделения", Объект.Подразделения.Выгрузить().ВыгрузитьКолонку("Подразделение"));
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СтрокаТовары = Объект.Товары.Добавить();
		СтрокаТовары.Номенклатура = Выборка.Номенклатура;
	КонецЦикла;	
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоАссортименту(Команда)
	ЗаполнитьПоАссортиментуНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//++саб
	сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка);
	//--саб
КонецПроцедуры

&НаСервере
Процедура сабПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	БюджетныйНаСервере.ДействияПриСозданииФормыДокумента(ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	сабОбщегоНазначенияБУХ.ФормаДокументаУУОбработкаБУПередЗаписью(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры
