﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ВсегоПодсистем = Метаданные.Подсистемы.сабУправленческийУчет.Подсистемы.сабУправленческийУчетСлужебная.Подсистемы.сабГруппировкаУчетныхДокументовПереопределяемый.Подсистемы.Количество();
		
	ИндексГруппы = 1;
	ОбщийИндекс = 1;
	Для каждого ТекПодсистема Из Метаданные.Подсистемы.сабДокументооборот.Подсистемы.сабДокументооборотСлужебная.Подсистемы.сабГруппировкаВнутреннихДокументовПереопределяемый.Подсистемы Цикл
		ЭлементГруппа = СоздатьЭлементГруппу(Элементы["Группа" + Строка(ИндексГруппы)], ТекПодсистема, ОбщийИндекс);		
		СоздатьЭлементыГруппы(ЭлементГруппа, ТекПодсистема);
		ИндексГруппы = ИндексГруппы + 1;
		Если ИндексГруппы > 4 Тогда
			ИндексГруппы = 1;		
		КонецЕсли;
		ОбщийИндекс = ОбщийИндекс + 1;
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Функция СоздатьЭлементГруппу(Родитель, ТекПодсистема, ОбщийИндекс)
	
	Если ОбщийИндекс > 4 Тогда
		Элементы.Добавить("Декорация" + ТекПодсистема.Имя, Тип("ДекорацияФормы"), Родитель);
	КонецЕсли;
	
	
	НоваяКнопка = Элементы.Найти("ГруппаФормы" + ТекПодсистема.Имя);
	Если НоваяКнопка = Неопределено Тогда
		НоваяКнопка = Элементы.Добавить("ГруппаФормы" + ТекПодсистема.Имя, Тип("ГруппаФормы"), Родитель);
	Иначе	
		//НоваяКнопка.Видимость = Истина;	
	КонецЕсли;
	НоваяКнопка.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	НоваяКнопка.Заголовок = ТекПодсистема.Синоним;
	НоваяКнопка.ОтображатьЗаголовок = Истина;
	НоваяКнопка.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	НоваяКнопка.Отображение = ОтображениеОбычнойГруппы.ОбычноеВыделение;
	
	Возврат Элементы["ГруппаФормы" + ТекПодсистема.Имя];
	
КонецФункции

&НаСервере
Процедура СоздатьЭлементыГруппы(Родитель, ТекПодсистема)
	
	ВремТЧ = Новый ТаблицаЗначений;
	ВремТЧ.Колонки.Добавить("Имя");
	ВремТЧ.Колонки.Добавить("Комментарий");
	ВремТЧ.Колонки.Добавить("Синоним");
	ВремТЧ.Колонки.Добавить("ПредставлениеСписка");
	ВремТЧ.Колонки.Добавить("ВидОперации");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Д_ВидыВнутреннихДокументов.ИмяДокумента КАК ИмяДокумента
	|ИЗ
	|	Справочник.Д_ВидыВнутреннихДокументов КАК Д_ВидыВнутреннихДокументов
	|ГДЕ
	|	НЕ Д_ВидыВнутреннихДокументов.ИмяДокумента = """"
	|
	|СГРУППИРОВАТЬ ПО
	|	Д_ВидыВнутреннихДокументов.ИмяДокумента";
	
	Запрос.УстановитьПараметр("", );
	
	Результат = Запрос.Выполнить();
	ВыборкаИмен = Результат.Выгрузить().ВыгрузитьКолонку("ИмяДокумента");
	
	
	Для Каждого ВидОперации Из ТекПодсистема.Состав Цикл
		Если ВыборкаИмен.Найти(ВидОперации.Имя) = Неопределено Тогда
			Продолжить;		
		КонецЕсли;
		
		НоваяСтрока = ВремТЧ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВидОперации);
		НоваяСтрока.ВидОперации = ВидОперации;
	КонецЦикла;
	
	ВремТЧ.Сортировать("Синоним");
	
	Для каждого ВидОперации Из ВремТЧ Цикл
			Если НЕ ВидимостьИДоступность(ВидОперации.ВидОперации) Тогда
				Продолжить;			
			КонецЕсли;
			
			ДобавитьПунктМеню(ВидОперации, Родитель);
			
			Для каждого ТекКомандаДокумента Из Метаданные.Документы[ВидОперации.Имя].Команды Цикл
				Если СтрНайти(ТекКомандаДокумента.Комментарий, "КомандаСписок") Тогда
					ИмяПеречисления1 = Прав(ТекКомандаДокумента.Комментарий,СтрДлина(ТекКомандаДокумента.Комментарий)-14);
					ВидОперации.ПредставлениеСписка = ТекКомандаДокумента.Синоним;
					ДобавитьПунктМеню(ВидОперации, Родитель, ИмяПеречисления1);
				КонецЕсли;
				
			
			КонецЦикла; 
			
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПунктМеню(ВидОперации, Родитель, ПодвидОперации = "")
	
	ИмяКоманды = ВидОперации.Имя + "__" + ПодвидОперации;
	
	НоваяКоманда = Команды.Найти("Команда" + ИмяКоманды);
	Если НоваяКоманда = Неопределено Тогда
		НоваяКоманда = Команды.Добавить("Команда" + ИмяКоманды);
	КонецЕсли;
	НоваяКоманда.Действие  = "ВыборВидаОперации";
	НоваяКнопка = Элементы.Найти("Команда" + ИмяКоманды);
	Если НоваяКнопка = Неопределено Тогда
		Если ЗначениеЗаполнено(ПодвидОперации) Тогда //подменю
			ГруппаПодменю = Элементы.Добавить("ГруппаФормы" +ИмяКоманды, Тип("ГруппаФормы"), Родитель); 
			ГруппаПодменю.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ГруппаПодменю.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			ГруппаПодменю.ОтображатьЗаголовок = Ложь;
			Элементы.Добавить("Декорация" + ИмяКоманды, Тип("ДекорацияФормы"), ГруппаПодменю);
			НоваяКнопка = Элементы.Добавить("Команда" +ИмяКоманды, Тип("КнопкаФормы"), ГруппаПодменю);
		Иначе
			НоваяКнопка = Элементы.Добавить("Команда" +ИмяКоманды, Тип("КнопкаФормы"), Родитель);	
		КонецЕсли;
		
	Иначе	
		НоваяКнопка.Видимость = Истина;	
	КонецЕсли;
	НоваяКнопка.Заголовок = ВидОперации.ПредставлениеСписка;
	НоваяКнопка.ИмяКоманды = "Команда" + ИмяКоманды;
	НоваяКнопка.Вид = ВидКнопкиФормы.Гиперссылка;
	
	
	//НоваяКнопка.Отступ = ?(Родитель = Неопределено, 0, 2);
	//НоваяКнопка.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	//НоваяКнопка.Подсказка = ВидОперации.Комментарий;
	//СтруктураСвойств.Вставить("Команда" + ВидОперации.Код, Новый Структура("Отступ, Подсказка", ?(Родитель = Неопределено, 0, 2), ВидОперации.Комментарий));
	
	Если НоваяКнопка.Заголовок = "Все документы" Тогда
		НовыйШрифт = Новый Шрифт(,10,Истина);
		НоваяКнопка.Шрифт = НовыйШрифт;
	Иначе
		НовыйШрифт = Новый Шрифт(,10);
		НоваяКнопка.Шрифт = НовыйШрифт;
	КонецЕсли;
	
	
	Если ЗначениеЗаполнено(ВидОперации.Комментарий) Тогда
		ДобавляемыеРеквизиты = Новый Массив; 
		Реквизит = Новый РеквизитФормы("Реквизит" + ИмяКоманды, Новый ОписаниеТипов("Строка")); 
		ДобавляемыеРеквизиты.Добавить(Реквизит); 
		ИзменитьРеквизиты(ДобавляемыеРеквизиты);
		НоваяКнопка = Элементы.Найти("ПолеФормы" + ИмяКоманды);
		Если НоваяКнопка = Неопределено И Родитель = Неопределено Тогда
			НоваяКнопка = Элементы.Добавить("ПолеФормы" + ИмяКоманды, Тип("ПолеФормы"),Родитель);
			НоваяКнопка.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			НоваяКнопка.ПутьКДанным  = "Реквизит" + ИмяКоманды;
			//НоваяКнопка.Гиперссылка = Истина;
			ЭтотОбъект["Реквизит" + ИмяКоманды] = ВидОперации.Комментарий;
		КонецЕсли;
	КонецЕсли;


КонецПроцедуры


&НаСервере
Функция ВидимостьИДоступность(ВидОперации)
	ВключенаВОпциях = Ложь;
	ЕстьВОпциях = Ложь;
	ЕстьПравоПросмотра = ПравоДоступа("Просмотр", ВидОперации);
	Для каждого ТекФункц Из Метаданные.ФункциональныеОпции Цикл
		Если НЕ ТекФункц.Состав.Найти(ВидОперации) = Неопределено Тогда
			ЕстьВОпциях = Истина;
			Если НЕ Метаданные.Константы.Найти(ТекФункц.Хранение.Имя) = Неопределено Тогда
				ВключенаВОпциях = МАКС(ВключенаВОпциях, Константы[ТекФункц.Хранение.Имя].Получить());
				Если ВключенаВОпциях Тогда
					Прервать;				
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат (ВключенаВОпциях ИЛИ НЕ ЕстьВОпциях) И ЕстьПравоПросмотра;
КонецФункции


&НаКлиенте
Процедура ВыборВидаОперации(Команда)
	
	
	
	КодВидаДокумента = Сред(Команда.Имя, 8, СтрНайти(Команда.Имя, "__")-8);
	
	ТекФорма = ПолучитьФорму("Документ." + КодВидаДокумента + ".ФормаСписка");
	
	ИмяПеречисления = Сред(Команда.Имя, СтрНайти(Команда.Имя, "__")+3, СтрНайти(Команда.Имя, "__",,,2)-(СтрНайти(Команда.Имя, "__")+3));
	ЗначениеПеречисления = Сред(Команда.Имя, СтрНайти(Команда.Имя, "__",,,2)+2, СтрНайти(Команда.Имя, "__",,,3)-(СтрНайти(Команда.Имя, "__",,,2)+2));
	
	Если ЗначениеЗаполнено(ИмяПеречисления) Тогда
		
		НовыйОтбор = ТекФорма.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВидОперации");
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = ПредопределенноеЗначение("Перечисление." + ИмяПеречисления + "." + ЗначениеПеречисления);
		ТекФорма.Заголовок = ПредопределенноеЗначение("Перечисление." + ИмяПеречисления + "." + ЗначениеПеречисления);
		
	КонецЕсли;
	
	ТекФорма.Открыть();
	
КонецПроцедуры

