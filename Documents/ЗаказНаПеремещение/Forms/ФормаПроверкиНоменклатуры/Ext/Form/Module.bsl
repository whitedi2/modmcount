﻿
&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	
	СтруктураНоменклатура = сабОперОбщегоНазначения.ПодобратНоменклатуруПоШК(ШтрихкодНоменклатуры);
	
	Если ТипЗнч(СтруктураНоменклатура) = Тип("Структура") Тогда
		Номенклатура = СтруктураНоменклатура.Номенклатура;
	ИначеЕсли НЕ СтруктураНоменклатура = Неопределено Тогда
		Номенклатура = СтруктураНоменклатура;
	Иначе
		Номенклатура = Неопределено;
		Сообщить("Не найдена номенклатура по штрихкоду " + ШтрихкодНоменклатуры);
	КонецЕсли;
	
	ЭтаФорма.ТекущийЭлемент = Элементы.Штрихкод;
	
	РасчитатьОстатки();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если МобильныйКлиент Или МобильноеПриложениеКлиент Тогда
		ЭтоМобильныйКлиент = Истина;
	#Иначе
		ЭтоМобильныйКлиент = Ложь;
	#КонецЕсли
	
	Если ЭтоМобильныйКлиент Тогда
		Элементы.НоменклатураНаименование.Шрифт = Новый Шрифт( , , Истина, , , , 80);
		Элементы.НоменклатураНаименованиеПолное.Шрифт = Новый Шрифт( , , Истина, , , , 80);
	КонецЕсли;
	
	ЭтаФорма.ТекущийЭлемент = Элементы.Штрихкод;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	
КонецПроцедуры

&НаСервере
Процедура РасчитатьОстатки()

	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	УчетныйОстатки.Субконто1 КАК Номенклатура,
	               |	УчетныйОстатки.Субконто2 КАК Склад,
	               |	УчетныйОстатки.Субконто3 КАК Серия,
	               |	УчетныйОстатки.КоличествоОстаток КАК Количество
	               |ИЗ
	               |	РегистрБухгалтерии.Учетный.Остатки(
	               |			,
	               |			Счет.Код = ""41"",
	               |			,
	               |			Предприятия В (&ДоступныеПредприятия)
	               |				И Субконто1 = &Номенклатура) КАК УчетныйОстатки";
	
	Запрос.УстановитьПараметр("ДоступныеПредприятия", ПараметрыСеанса.ДоступныеПредприятия);
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	ТЧОстатки.Очистить();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ТЧОстатки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);	
	КонецЦикла;
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры


&НаКлиенте
Процедура Обновить(Команда)
	ПриСозданииНаСервере(Ложь, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Найти2(Команда)
	ШтрихкодПриИзменении(Неопределено);
КонецПроцедуры
