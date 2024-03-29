﻿
&НаКлиенте
Процедура Проверен(Команда)
	
	//ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	//Для каждого ТекущиеДанные Из Элементы.Список.ВыделенныеСтроки Цикл
		//ПроверенНаСервере(ТекущиеДанные.Объект);
		//Элементы.Список.Обновить();
	//КонецЦикла; 
	
	ТекущийОбъект = Элементы.Список.ТекущиеДанные.Объект;	
	ОтветственныйЗаСправочник = ПолучитьОтветственного(ТекущийОбъект);
	
	Если БюджетныйНаСервере.ПолучитьПользователя() <> ОтветственныйЗаСправочник Или Не БюджетныйНаСервере.РольАдминаДоступнаСервер() Тогда
		Предупреждение("Вы не являетесь ответственным за данный справочник");
		Возврат;
	КонецЕсли;
	ПроверенНаСервере(ТекущийОбъект);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура ПроверенНаСервере(ТекСсылка)
	
	НаборЗаписей = РегистрыСведений.ПроверкаОбъектовБД.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ТекСсылка);
	НаборЗаписей.Прочитать();
	НаборЗаписей.Очистить();
	Запись 				= НаборЗаписей.Добавить();
	Запись.Объект	 	= ТекСсылка;
	Запись.Проверен 	= Истина;
	Запись.Статус		= Перечисления.СтатусПриПроверкеОбъектовБД.Проверен;
	НаборЗаписей.Записать();
	
	//помечаем проверено все строки регистра контроля изменений реквизитов справочников
	НаборЗаписей = РегистрыСведений.ИзмененияРеквизитовОбъектовИБ.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Объект.Установить(ТекСсылка);
	НаборЗаписей.Прочитать();
	Для каждого ИзменениеПроверено Из НаборЗаписей Цикл
		ИзменениеПроверено.ИзменениеПроверено = Истина;
	КонецЦикла;
	НаборЗаписей.Записать();
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если НЕ Элемент.ТекущиеДанные = Неопределено Тогда
		УстановитьОтборПоИзменениям(Элемент.ТекущиеДанные.Объект);
	КонецЕсли;;	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоИзменениям(Ссылка)
	
	ЭлементыДляУдаления = Новый Массив;
	
	ЭлементыОтбора = СписокИзменений.Отбор.Элементы;
	ПолеКомпоновки = Новый ПолеКомпоновкиДанных("Объект");
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ТипЗнч(ЭлементОтбора) = Тип("ЭлементОтбораКомпоновкиДанных")
			И ЭлементОтбора.ЛевоеЗначение = ПолеКомпоновки Тогда
			ЭлементыДляУдаления.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ЭлементОтбораДляУдаления Из ЭлементыДляУдаления Цикл
		ЭлементыОтбора.Удалить(ЭлементОтбораДляУдаления);
	КонецЦикла;	
	
	ЭлементОтбора = СписокИзменений.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Объект");	
	ЭлементОтбора.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.Использование  = Истина;
	ЭлементОтбора.ПравоеЗначение = Ссылка;

КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ Элементы.Список.ТекущиеДанные = Неопределено Тогда
		УстановитьОтборПоИзменениям(Элементы.Список.ТекущиеДанные.Объект);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ОтветственныеЗаПроверкуСправочников.Ответственный
	               |ИЗ
	               |	РегистрСведений.ОтветственныеЗаПроверкуСправочников КАК ОтветственныеЗаПроверкуСправочников";
	МассивОтветственных = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ответственный");
	//МассивОтветственных.Добавить(Константы.СотрудникОФК.Получить());
	//МассивОтветственных.Добавить(Константы.ОтветственныйЗаСправочникДолжностей.Получить());
	//МассивОтветственных.Добавить(Константы.ОтветственныйЗаСправочникНоменклатура.Получить());
	
	Если Не РольДоступна("Администратор") Тогда
		Если МассивОтветственных.Найти(ПараметрыСеанса.ТекущийПользователь) = Неопределено Тогда
			Сообщить("Недостаточно прав!");
			Отказ = Истина;
		КонецЕсли;	
	КонецЕсли;
	
	СписокИзменений.Параметры.УстановитьЗначениеПараметра("Период", ТекущаяДата());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаменитьСсылки(Команда)
	
	Если Не Элементы.Список.ТекущиеДанные = Неопределено Тогда
		СтруктураПараметров = Новый Структура("Ссылка", Элементы.Список.ТекущиеДанные.Объект);
		ОткрытьФорму("Обработка.ПоискИЗаменаЗначений.Форма.Форма", СтруктураПараметров);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьОтветственного(Объект)
	
	Если ТипЗнч(Объект) = Тип("СправочникСсылка.Номенклатура") Тогда
		Возврат ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Номенклатура, Объект.НаправлениеДеятельности);
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Контрагенты") Тогда
		Возврат ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Контрагенты);
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Организации") Тогда
		Возврат ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Организации);
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникСсылка.Должности") Тогда
		Возврат ОбщегоНазначения.ПолучитьОтветственногоЗаСправочник(Перечисления.ТипыПроверяемыхСправочников.Должности);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
		
КонецФункции
