﻿
&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Не Элементы.Список.ТекущиеДанные = Неопределено И Не Элементы.Список.ТекущиеДанные.Проверен Тогда
		Если Вопрос("Данная должность не проверена. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			ЭтаФорма.ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
		Иначе
			Возврат;
		КонецЕсли;
		
	КонецЕсли;	
	ЭтаФорма.ОповеститьОВыборе(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если Не Элементы.Список.ТекущиеДанные = Неопределено И Не Элементы.Список.ТекущиеДанные.Проверен Тогда
		Если Вопрос("Данная Должность не проверена. Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			СтандартнаяОбработка = Ложь;
        КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Должность = Неопределено;
	Иначе
		Должность = Элемент.ТекущиеДанные.Ссылка;
	КонецЕсли;	
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = СотрудникиПоДолжностям.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных("Должность");
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;	
	
	ЭлементОтбора = СотрудникиПоДолжностям.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Должность");	
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ПравоеЗначение = Должность;
	
КонецПроцедуры
