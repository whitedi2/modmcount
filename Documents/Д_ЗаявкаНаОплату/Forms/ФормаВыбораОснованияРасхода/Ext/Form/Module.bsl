﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("СтатьяДДС") Тогда
		СтандартнаяОбработка = Ложь;
		Возврат;	
	КонецЕсли;
	
	
	АктуальныйСценарий = БюджетныйНаСервере.ПолучитьАктуальныйСценарий(ТекущаяДата());
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	СценарииПланирования.Ссылка
	|ИЗ
	|	Справочник.СценарииПланирования КАК СценарииПланирования
	|ГДЕ
	|	СценарииПланирования.Родитель = &Родитель
	|	И СценарииПланирования.ВлкючатьВПлан = ИСТИНА";
	
	Запрос.УстановитьПараметр("Родитель", АктуальныйСценарий);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	МассивСценариев = Новый Массив;
	МассивСценариев.Добавить(АктуальныйСценарий);
	
	Пока Выборка.Следующий() Цикл
		
		МассивСценариев.Добавить(Выборка.Ссылка);	
		
	КонецЦикла;
	
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	БюджетныйДвиженияССубконто.Содержание КАК Основание,
	               |	ЕСТЬNULL(БюджетныйДвиженияССубконто.Сумма, 0) КАК Сумма
	               |ИЗ
	               |	РегистрБухгалтерии.Бюджетный.ДвиженияССубконто(
	               |			&Дата1,
	               |			&Дата2,
	               |			(СчетДт В (&Счет)
	               |				ИЛИ СчетКт В (&Счет))
	               |				И СценарийПлана В (&Сценарий)
	               |				И Предприятия В (&Предприятия)
	               |				И (Субконто1 = &СтатьяДДС
	               |					ИЛИ КорСубконто1 = &СтатьяДДС),
	               |			,
	               |			) КАК БюджетныйДвиженияССубконто";
	
	МассивСчетов = Новый Массив;
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет5001());
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет5101());
	МассивСчетов.Добавить(ПланыСчетов.Учетный.Счет5501());
	
	Запрос.УстановитьПараметр("Дата1", НачалоМесяца(Параметры.ДатаДока));
	Запрос.УстановитьПараметр("Дата2", КонецМесяца(Параметры.ДатаДока));
	Запрос.УстановитьПараметр("Счет", МассивСчетов);
	Запрос.УстановитьПараметр("Предприятия", Параметры.ЦФО);
	Запрос.УстановитьПараметр("СтатьяДДС", Параметры.СтатьяДДС);
	Запрос.УстановитьПараметр("Сценарий", МассивСценариев);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = РасшифровкаСтатьи.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РасшифровкаСтатьиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Закрыть(Элементы.РасшифровкаСтатьи.ТекущиеДанные.Основание);
КонецПроцедуры
