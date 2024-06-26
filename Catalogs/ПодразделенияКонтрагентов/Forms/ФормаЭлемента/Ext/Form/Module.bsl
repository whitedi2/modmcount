﻿
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ОбновитьДанныеВЗаказе",,?(ТипЗнч(ЭтаФорма.ВладелецФормы) = Тип("ПолеФормы"), ЭтаФорма.ВладелецФормы.ТекстРедактирования, Неопределено));
КонецПроцедуры

&НаКлиенте
Процедура Подобрать(Команда)
	
	ДопПараметры = Новый Структура("ОткрытаПоСценарию,Заголовок,Представление",Истина,"Подбор адреса",Объект.Адрес);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПослеПодбораАдреса",ЭтотОбъект);  
	ОткрытьФорму("Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВводАдреса",ДопПараметры,ЭтотОбъект,,,,ОписаниеОповещения);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПослеПодбораАдреса(Результат,ДопПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Если Результат.Свойство("Представление") Тогда
				Если ЗначениеЗаполнено(Результат.Представление) Тогда
			        Объект.Адрес = Результат.Представление;
					Модифицированность = Истина;
                 КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьАдресКонтрагента(Контрагент)
	
	АдресКонтрагента = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Контрагент, Перечисления.ТипыКонтактнойИнформации.Адрес,,Истина);
    Возврат АдресКонтрагента;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресТекущегоПредприятия()
	
	АдресПредприятия = ПараметрыСеанса.ТекущееПредприятие.Адрес;
    Возврат АдресПредприятия;
	
КонецФункции

&НаКлиенте
Процедура ПоказатьНаКарте(Команда)
	
	АдресКонтрагента = "";
	Если Не ЗначениеЗаполнено(Объект.Адрес) Тогда
	 	АдресКонтрагента = ПолучитьАдресКонтрагента(Объект.Владелец);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Адрес) Тогда
		Адрес = Объект.Адрес;
	ИначеЕсли ЗначениеЗаполнено(АдресКонтрагента) Тогда
        Адрес = АдресКонтрагента;
	Иначе
		Адрес = "г. Воронеж";
	КонецЕсли;
				
	//Если ЗначениеЗаполнено(Объект.Адрес) Тогда 
		СтруктураПараметров = Новый Структура("Адрес",Адрес);  
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыСВозвратомДанных",ЭтотОбъект);
		ОткрытьФорму("Справочник.ПодразделенияКонтрагентов.Форма.ФормаКарты",СтруктураПараметров,ЭтотОбъект,,,,ОписаниеОповещения); 
	//КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьКоординатыНаСервере(АдресСтрока) 
	
	Координаты = Неопределено;
	Попытка
		Адрес = "/maps/?text=" + АдресСтрока;
		ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
		БезопасноеСоединение = Новый HTTPСоединение("yandex.ru",443,,,,,ЗащищенноеСоединение);
		Ответ = БезопасноеСоединение.Получить(Новый HTTPЗапрос(Адрес));
		Если Ответ.КодСостояния = 200 Тогда
			Результат = Ответ.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
			Чтение = Новый ЧтениеHTML;
			
			Чтение.УстановитьСтроку(Результат);
			ОбъектыDOM = Новый ПостроительDOM;
			Данные = ОбъектыDOM.Прочитать(Чтение);
			ТекстКарты = Данные.ИзвлечьТолькоТекст();
			ПервыйСимвол = СтрНайти(ТекстКарты,"Координаты:");
			Если ПервыйСимвол > 0 Тогда
				ПервыйСимвол = ПервыйСимвол + 11;
			КонецЕсли;
			КрайнийСимвол = СтрНайти(ТекстКарты,"МаршрутОбзор");
			Если ПервыйСимвол > 0 И КрайнийСимвол > ПервыйСимвол Тогда
				Координаты = Сред(ТекстКарты,ПервыйСимвол,КрайнийСимвол - ПервыйСимвол); 
			Иначе
				Сообщить("Кординаты не распознаны");   
			КонецЕсли;
		Иначе
			Сообщить("Кординаты не подобраны. Ошибка ответа сервера (" + Ответ.КодСостояния + ")");
		КонецЕсли;
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки; 
	Возврат Координаты;
	
КонецФункции

&НаКлиенте
Процедура ПолучитьКоординаты(Команда)
	
	Если ЗначениеЗаполнено(Объект.Адрес) Тогда
		Координаты = ПолучитьКоординатыНаСервере(Объект.Адрес);
		Если Координаты <> Неопределено Тогда
			Объект.Координаты = Координаты;	
		КонецЕсли;
	Иначе
		Сообщить("Адрес не заполнен.");
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыСВозвратомДанных(Результат,ДопПараметры) Экспорт 
	
	Если ЗначениеЗаполнено(Результат) Тогда
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Если Результат.Свойство("Адрес") Тогда
				Объект.Адрес = Результат.Адрес;
			КонецЕсли;
			Если Результат.Свойство("Координаты") Тогда
				Объект.Координаты = Результат.Координаты;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНаКартеКоординаты(Команда)
	
	АдресКонтрагента = "";
	Если Не ЗначениеЗаполнено(Объект.Координаты) Тогда
	 	АдресКонтрагента = ПолучитьАдресКонтрагента(Объект.Владелец);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Координаты) Тогда
		Адрес = Объект.Координаты;
	ИначеЕсли ЗначениеЗаполнено(Объект.Адрес) Тогда
		Адрес = Объект.Адрес;
	ИначеЕсли ЗначениеЗаполнено(АдресКонтрагента) Тогда
        Адрес = АдресКонтрагента;
	Иначе
		Адрес = "г. Воронеж";
	КонецЕсли;

	//Если ЗначениеЗаполнено(Объект.Координаты) Тогда 
		СтруктураПараметров = Новый Структура("Адрес",Адрес);  
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗакрытияФормыСВозвратомДанных",ЭтотОбъект);
		ОткрытьФорму("Справочник.ПодразделенияКонтрагентов.Форма.ФормаКарты",СтруктураПараметров,ЭтотОбъект,,,,ОписаниеОповещения);
	//КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьДоступностьВремениДоставки(Объект.ВремяПоДнямНеделиПереключатель,Элементы.ГруппаВремяДоставкиПоДнямНедели,Элементы.ДатаДоставки1,Элементы.ДатаДоставкиДо); 

КонецПроцедуры

&НаКлиенте
Процедура ВремяПоДнямНеделиПереключательПриИзменении(Элемент)
	
	УстановитьДоступностьВремениДоставки(Объект.ВремяПоДнямНеделиПереключатель,Элементы.ГруппаВремяДоставкиПоДнямНедели,Элементы.ДатаДоставки1,Элементы.ДатаДоставкиДо); 
	
КонецПроцедуры  

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьВремениДоставки(ВремяПоДнямНеделиПереключатель,ГруппаВремяДоставкиПоДнямНедели,ДатаДоставки1,ДатаДоставкиДо)

	ГруппаВремяДоставкиПоДнямНедели.Доступность = ВремяПоДнямНеделиПереключатель;
	ДатаДоставки1.Доступность = Не ВремяПоДнямНеделиПереключатель;
    ДатаДоставкиДо.Доступность = Не ВремяПоДнямНеделиПереключатель; 
	Если ВремяПоДнямНеделиПереключатель Тогда
		ГруппаВремяДоставкиПоДнямНедели.Показать();
	Иначе
		ГруппаВремяДоставкиПоДнямНедели.Скрыть();
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ПослеВводаСведенийНаселенногоПункта(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ГородРегионСтруктура = ГородРегионСтрокой(Результат.НаселенныйПунктДетально);
		Объект.Регион = ГородРегионСтруктура.Регион; 
		Объект.НаселенныйПункт = ГородРегионСтруктура.Город;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ГородРегионСтрокой(Результат) 
	
	СтруктураАдреса = Новый Структура("Регион,Город");
	СтруктураАдреса.Регион = РаботаСАдресами.РегионАдресаКонтактнойИнформации(Результат);
	СтруктураАдреса.Город = РаботаСАдресами.ГородАдресаКонтактнойИнформации(Результат);
	Возврат СтруктураАдреса   
	
КонецФункции
&НаСервере
Функция ПараметрыОткрытияФормыНаселенногоПункта()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НаселенныйПунктДетально", Неопределено);
	ПараметрыФормы.Вставить("ОтображатьКнопкиВыбора",  Истина);
	ПараметрыФормы.Вставить("ТипАдреса",               "");
	
	Возврат ПараметрыФормы;
	
КонецФункции

&НаКлиенте
Процедура ПодобратьГородРегион(Команда)
	
	ПараметрыФормы = ПараметрыОткрытияФормыНаселенногоПункта(); 
	Оповещение = Новый ОписаниеОповещения("ПослеВводаСведенийНаселенногоПункта", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.РасширенныйВводКонтактнойИнформации.Форма.НаселенныйПунктАдреса", ПараметрыФормы, 
	Элементы.ПодобратьГородРегион,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);  
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьГородРегион(Команда)
	
	ЗаполнитьГородРегионПоАдресу(Объект.Регион,Объект.НаселенныйПункт,Объект.Адрес);
	
КонецПроцедуры  


&НаСервереБезКонтекста
Процедура ЗаполнитьГородРегионПоАдресу(Регион, Город, Адрес)

	Регион = Справочники.ПодразделенияКонтрагентов.ПолучитьРегионСтрокой(Адрес);
	Город =Справочники.ПодразделенияКонтрагентов.ПолучитьГородСтрокой(Адрес);

КонецПроцедуры
