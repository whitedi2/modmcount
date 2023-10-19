﻿#Область ГенерированиеДереваМаршрутов

&НаСервере
Процедура ДобавитьДеревоМаршрута(Элементы, Команды, ТекущаяСтрокаГруппы, МаршрутДерево, ТекАвтоМар, УсловноеОформление, СтруктураДопПараметров) Экспорт
	
	Если СтруктураДопПараметров.Свойство("ДопУсловияВидимость") Тогда
		ДопУсловия = СтруктураДопПараметров.ДопУсловияВидимость;
	Иначе
		ДопУсловия = Истина;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("ВремяНаВыполнение") Тогда
		ВремяНаВыполнение = СтруктураДопПараметров.ВремяНаВыполнение;
	Иначе
		ВремяНаВыполнение = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("ДоступенТипПользователи") Тогда
		ОграничитьТипПользователями = СтруктураДопПараметров.ДоступенТипПользователи;
	Иначе
		ОграничитьТипПользователями = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("КнопкиУправления") Тогда
		КнопкиУправления = СтруктураДопПараметров.КнопкиУправления;
	Иначе
		КнопкиУправления = Истина;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("СкрытьПанель") Тогда
		СкрытьПанель = СтруктураДопПараметров.СкрытьПанель;
	Иначе
		СкрытьПанель = Ложь;	
	КонецЕсли;

	Если СтруктураДопПараметров.Свойство("ТолькоПросмотр") Тогда
		ТолькоПросмотр = СтруктураДопПараметров.ТолькоПросмотр;
	Иначе
		ТолькоПросмотр = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("ТекущийИсполнитель") Тогда
		ТекущийПользователь = СтруктураДопПараметров.ТекущийИсполнитель;
	Иначе
		ТекущийПользователь = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("Согласовано") Тогда
		Согласовано = СтруктураДопПараметров.Согласовано;
	Иначе
		Согласовано = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("Согласователь") Тогда
		Согласователь = СтруктураДопПараметров.Согласователь;
	Иначе
		Согласователь = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("Обязателен") Тогда
		Обязателен = СтруктураДопПараметров.Обязателен;
	Иначе
		Обязателен = Ложь;	
	КонецЕсли;
	
	Если СтруктураДопПараметров.Свойство("МожетРедактировать") Тогда
		МожетРедактировать = СтруктураДопПараметров.МожетРедактировать;
	Иначе
		МожетРедактировать = Ложь;	
	КонецЕсли;

	
	Если Элементы.Найти("ТаблицаФормы123") = Неопределено И НЕ Элементы.Найти("НовыйВидМаршрута") = Неопределено Тогда
		
		Таблица = Элементы.Добавить("ТаблицаФормы123", Тип("ТаблицаФормы"), Элементы.НовыйВидМаршрута);
		Таблица.ПутьКДанным = "МаршрутДерево";
		Колонка = Элементы.Добавить("Колонка1", Тип("ПолеФормы"), Таблица);
		Колонка.ПутьКДанным = "МаршрутДерево.Пользователь";
		Колонка.Вид = ВидПоляФормы.ПолеВвода;
		Колонка.УстановитьДействие("НачалоВыбора", "Реквизит1ДопСогласованиеСубъектСогласованияНачалоВыбора");
		Колонка.УстановитьДействие("АвтоПодбор", "Реквизит1ДопИсполнениеСубъектСогласованияАвтоПодбор");
		
		//Колонка = Элементы.Добавить("Колонка3", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.ТекущаяСтрокаГруппы";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		Если ДопУсловия Тогда
			Колонка3 = Элементы.Добавить("Колонка3", Тип("ПолеФормы"), Таблица);
			Колонка3.ПутьКДанным = "МаршрутДерево.ДопУсловия";
			Колонка3.Вид = ВидПоляФормы.ПолеВвода;
			Колонка3.КнопкаВыбора = Истина;
		КонецЕсли;
		
		Если ТекущийПользователь Тогда
			Колонка5 = Элементы.Добавить("Колонка5", Тип("ПолеФормы"), Таблица);
			Колонка5.ПутьКДанным = "МаршрутДерево.ТекущийИсполнитель";
			Колонка5.Вид = ВидПоляФормы.ПолеФлажка;
			Элементы["Колонка5"].ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Если Согласовано Тогда
			Колонка6 = Элементы.Добавить("Колонка6", Тип("ПолеФормы"), Таблица);
			Колонка6.ПутьКДанным = "МаршрутДерево.Согласовано";
			Колонка6.Заголовок = "Акцепт";
			Колонка6.Вид = ВидПоляФормы.ПолеФлажка;
			
			Колонка7 = Элементы.Добавить("Колонка7", Тип("ПолеФормы"), Таблица);
			Колонка7.ПутьКДанным = "МаршрутДерево.Пройден";
			Колонка7.Вид = ВидПоляФормы.ПолеФлажка;
			
			Колонка8 = Элементы.Добавить("Колонка8", Тип("ПолеФормы"), Таблица);
			Колонка8.ПутьКДанным = "МаршрутДерево.Комментарии";
			Колонка8.Вид = ВидПоляФормы.ПолеВвода;
			
			Если Согласователь Тогда
				Колонка81 = Элементы.Добавить("Колонка81", Тип("ПолеФормы"), Таблица);
				Колонка81.ПутьКДанным = "МаршрутДерево.Согласователь";
				Колонка81.Заголовок = "Факт. исполнитель";
				Колонка81.Вид = ВидПоляФормы.ПолеВвода;
			КонецЕсли;

		Иначе
			//Колонка = Элементы.Добавить("Колонка2", Тип("ПолеФормы"), Таблица);
			//Колонка.ПутьКДанным = "МаршрутДерево.РольПользователя";
			//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		КонецЕсли;
		
		Если Обязателен Тогда
			Колонка = Элементы.Добавить("Колонка2", Тип("ПолеФормы"), Таблица);
			Колонка.ПутьКДанным = "МаршрутДерево.РольПользователя";
			Колонка.Вид = ВидПоляФормы.ПолеВвода;
		КонецЕсли;
		
		Если ВремяНаВыполнение Тогда
			Колонка4 = Элементы.Добавить("Колонка4", Тип("ПолеФормы"), Таблица);
			Колонка4.ПутьКДанным = "МаршрутДерево.ВремяНаВыполнение";
			Колонка4.Заголовок = "Срок, ч.";
			Колонка4.Вид = ВидПоляФормы.ПолеВвода;
			//Колонка3.КнопкаВыбора = Истина;
		КонецЕсли;
		
		Если Обязателен Тогда
			Колонка4 = Элементы.Добавить("Колонка9", Тип("ПолеФормы"), Таблица);
			Колонка4.ПутьКДанным = "МаршрутДерево.Обязателен";
			Колонка4.Вид = ВидПоляФормы.ПолеВвода;
			//Колонка3.КнопкаВыбора = Истина;
			
			Колонка4 = Элементы.Добавить("Колонка10", Тип("ПолеФормы"), Таблица);
			Колонка4.ПутьКДанным = "МаршрутДерево.МожетРедактировать";
			Колонка4.Вид = ВидПоляФормы.ПолеВвода;
			//Колонка3.КнопкаВыбора = Истина;
		КонецЕсли;
		
		
		Элементы.ТаблицаФормы123.ТолькоПРосмотр = ТолькоПросмотр;
		
		//вспом столбцы (для отладки)
		//Колонка = Элементы.Добавить("Колонка44", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.ЭтоГруппа";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		//Колонка = Элементы.Добавить("Колонка45", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.Уровень";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		//Колонка = Элементы.Добавить("Колонка47", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.ТипГруппы";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		//Колонка = Элементы.Добавить("Колонка48", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.ИДГруппы";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		//Колонка = Элементы.Добавить("Колонка49", Тип("ПолеФормы"), Таблица);
		//Колонка.ПутьКДанным = "МаршрутДерево.ТекущаяСтрокаГруппы";
		//Колонка.Вид = ВидПоляФормы.ПолеВвода;
		
		//конец вспом столбцов
		
		Таблица.УстановитьДействие("ПередНачаломИзменения", "Реквизит1ПередНачаломИзменения");
		Таблица.УстановитьДействие("ПриНачалеРедактирования", "Реквизит1ПриНачалеРедактирования");
		Таблица.УстановитьДействие("ПередУдалением", "Реквизит1ПередУдалением");
		Таблица.УстановитьДействие("ПриОкончанииРедактирования", "Реквизит1ПриОкончанииРедактирования");
		Таблица.УстановитьДействие("ПередНачаломДобавления", "Реквизит1ПередНачаломДобавления");
		Таблица.УстановитьДействие("ПриНачалеРедактирования", "Реквизит1ПриНачалеРедактирования");
		Таблица.УстановитьДействие("Перетаскивание", "Реквизит1Перетаскивание");
		Таблица.УстановитьДействие("ПриАктивизацииСтроки", "Реквизит1ПриАктивизацииСтроки");
		
		Если ДопУсловия Тогда
			Колонка3.УстановитьДействие("НачалоВыбора", "Реквизит1ДопУсловияНачалоВыбора");
		КонецЕсли;
		
		Если КнопкиУправления Тогда
			НоваяКоманда = Команды.Добавить("КомандаДобавитьГруппу");
			НоваяКоманда.Действие  = "ДобавитьГруппу";
			НоваяКоманда.Картинка = БиблиотекаКартинок.СоздатьГруппу;
			НоваяКоманда.Отображение = ОтображениеКнопки.Картинка;
			НоваяКнопка = Элементы.Добавить("КомандаДобавитьГруппу", Тип("КнопкаФормы"),Элементы.ТаблицаФормы123.КоманднаяПанель);
			НоваяКнопка.Заголовок = "Добавить группу";
			НоваяКнопка.ИмяКоманды = "КомандаДобавитьГруппу";
		Иначе
			//Элементы.ТаблицаФормы123.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
			//Элементы.ТаблицаФормы123.Автозаполнение = Ложь;
			НоваяКоманда = Команды.Добавить("СообщениеПользователю");
			НоваяКоманда.Действие  = "СообщениеПользователю";
			НоваяКоманда.Картинка = БиблиотекаКартинок.СвернутьВсе;
			НоваяКоманда.Отображение = ОтображениеКнопки.Картинка;
			НоваяКнопка = Элементы.Добавить("СообщениеПользователю", Тип("КнопкаФормы"),Элементы.ТаблицаФормы123.КоманднаяПанель);
			НоваяКнопка.Заголовок = "Сообщение пользователю";
			НоваяКнопка.ИмяКоманды = "СообщениеПользователю";
			
		КонецЕсли;
		
		Если СкрытьПанель Тогда
			Элементы.ТаблицаФормы123.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;		
		КонецЕсли;
		
	КонецЕсли;
	
	
	//
	////условное оформление
	//ЭлУслОф = УсловноеОформление.Элементы.Добавить(Тип("КоллекцияЭлементовУсловногоОформленияКомпоновкиДанных")).Отбор.Элементы.Добавить(Тип("КоллекцияЭлементовОтбораКомпоновкиДанных"));
	//ЭлУслОф.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаршрутДерево.Уровень");
	//ЭлУслОф.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ЭлУслОф.ПравоеЗначение = 0;
	//
	//ЭлУслОф2 = УсловноеОформление.Элементы.Добавить(Тип("ЭлементУсловногоОформления")).Оформление.Элементы[0].Значение
	//
	//
	
	//НоваяКнопка = Элементы.Добавить("Удалить111", Тип("КнопкаФормы"),Элементы.ТаблицаФормы123.КоманднаяПанель);
	//НоваяКнопка.ИмяКоманды = "УдалитьСтроки";
	//НоваяКнопка.ТолькоВоВсехДействиях = Ложь;
	
	Массив = Новый Массив;
	Массив.Добавить(Тип("СправочникСсылка.Пользователи"));
	Массив.Добавить(Тип("СправочникСсылка.ГруппыПользователей"));
	Если НЕ ОграничитьТипПользователями Тогда
		Массив.Добавить(Тип("ПеречислениеСсылка.ОсновныеДолжностиПредприятия"));
		Массив.Добавить(Тип("СправочникСсылка.Должности"));
	КонецЕсли;
	ОписаниеТиповС = Новый ОписаниеТипов(Массив);
	
	Элементы.Колонка1.ОграничениеТипа = ОписаниеТиповС;
	
	//ТекАвтоМар = Справочники.МаршрутыДвиженияЗаявок.НайтиПоКоду("000000001");
	
	ЗаполнитьМаршрутДеревоИзПлоскогоМаршрута(ТекАвтоМар, МаршрутДерево, ТипЗнч(ТекАвтоМар), СтруктураДопПараметров);
	
	Если Не УсловноеОформление = Неопределено Тогда
		ЗаполнитьУсловноеОформление(УсловноеОформление);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУсловноеОформление(УсловноеОформление)
	
	СписЗнч = Новый СписокЗначений;
	СписЗнч.Добавить("Согласование");
	СписЗнч.Добавить("Исполнение");
	СписЗнч.Добавить("Ознакомление");
	//УсловноеОформление.Элементы.Очистить();
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаФормы123");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаршрутДерево.Пользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписЗнч;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаФормы123");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаршрутДерево.Пользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписЗнч;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", Новый Цвет(244, 236, 197));
	
	
	СписЗнч = Новый СписокЗначений;
	СписЗнч.Добавить("Группа И");
	СписЗнч.Добавить("Группа ИЛИ");
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаФормы123");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаршрутДерево.Пользователь");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = СписЗнч;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,,Истина));
	
	//жирный на обязателен
	Элемент = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("ТаблицаФормы123");
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаршрутДерево.Обязателен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(,,Истина));
	
	
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьМаршрутДеревоИзПлоскогоМаршрута(ТекАвтоМар, МаршрутДерево, ЗаполнениеПоБП = Неопределено, СтруктураДопПараметров = Неопределено) Экспорт
	
	ЭтоАвтомаршрут = Ложь;
	Если ЗаполнениеПоБП = Тип("СправочникСсылка.МаршрутыДвиженияЗаявок") Тогда
		ЭтоАвтомаршрут = Истина;
	ИначеЕсли ЗаполнениеПоБП = Тип("ДанныеФормыСтруктура") И ТекАвтоМар.Свойство("МаршрутЗаявки") Тогда
		ЭтоАвтомаршрут = Истина;
	КонецЕсли;
	
	Если ЭтоАвтомаршрут Тогда
		ИмяТЧ1 = "МаршрутЗаявки";	
		ИмяТЧ2 = "МаршрутИсполнения";
		ИмяТЧ3 = "МаршрутОзнакомления";
	Иначе
		ИмяТЧ1 = "ДопСогласование";	
		ИмяТЧ2 = "ДопИсполнение";
		ИмяТЧ3 = "ДопОповещение";
	КонецЕсли; 
	
	МаршрутДерево.ПолучитьЭлементы().Очистить();


	
	ТекРодитель = Новый Массив;
	НоваяСтрока = Новый Массив;
	ТекРодитель.Вставить(0, МаршрутДерево.ПолучитьЭлементы());	
	
	ЕстьЭлементы = МаршрутДерево.ПолучитьЭлементы().Количество();
		
	Если НЕ ЕстьЭлементы Тогда
		НоваяСтрока.Вставить(0, ТекРодитель[0].Добавить());
		НоваяСтрока[0].Пользователь = "Согласование";	
		НоваяСтрока[0].ИДГруппы = 1;
	Иначе
		НоваяСтрока.Вставить(0, МаршрутДерево.ПолучитьЭлементы().Получить(0));
	КонецЕсли;
	
	Попытка
		ЗаполнитьУровень(НоваяСтрока[0].ПолучитьЭлементы(), ТекАвтоМар[ИмяТЧ1], Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"), 1, 0, "Согласование", СтруктураДопПараметров);
	Исключение
	КонецПопытки;
	
	Если НЕ ЕстьЭлементы Тогда
		НоваяСтрока.Вставить(0, ТекРодитель[0].Добавить());
		НоваяСтрока[0].Пользователь = "Исполнение";	
		НоваяСтрока[0].ИДГруппы = 1;
	Иначе
		НоваяСтрока.Вставить(0, МаршрутДерево.ПолучитьЭлементы().Получить(1));
	КонецЕсли;
	
	Если НЕ СтруктураДопПараметров = Неопределено И СтруктураДопПараметров.Свойство("ГруппаИИсполнителей") И СтруктураДопПараметров.ГруппаИИсполнителей Тогда //группируем исполнителей в группуИ (для исполнения оплаты)
		//ТекСтрокаКоллекц = НоваяСтрока[0].ПолучитьЭлементы().Добавить();
		//ТекСтрокаКоллекц.Пользователь = "Группа И";
		//ТекСтрокаКоллекц.Уровень = 1;
		ИДГруппы = Новый УникальныйИдентификатор;
		//ТекСтрокаКоллекц.ИДГруппы = ИДГруппы;
		Для каждого ТекСтрока Из ТекАвтоМар[ИмяТЧ2] Цикл
			ТекСтрока.Уровень = 2;
			ТекСтрока.ТипГруппы = "Группа И";
			ТекСтрока.ИДГруппы = ИДГруппы;
		КонецЦикла; 
	Иначе
		//ТекСтрокаКоллекц = НоваяСтрока[0];
		//ТекУровень = 1;
	КонецЕсли;
	
	Попытка
		ЗаполнитьУровень(НоваяСтрока[0].ПолучитьЭлементы(), ТекАвтоМар[ИмяТЧ2], Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"), 1, 0, "Исполнение", СтруктураДопПараметров);
	Исключение
	КонецПопытки;
	
	
	
	Если НЕ ЕстьЭлементы Тогда
		НоваяСтрока.Вставить(0, ТекРодитель[0].Добавить());
		НоваяСтрока[0].Пользователь = "Ознакомление";	
		НоваяСтрока[0].ИДГруппы = 1;
	Иначе
		НоваяСтрока.Вставить(0, МаршрутДерево.ПолучитьЭлементы().Получить(2));
	КонецЕсли;
	
	Попытка
		ЗаполнитьУровень(НоваяСтрока[0].ПолучитьЭлементы(), ТекАвтоМар[ИмяТЧ3], Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"), 1, 0, "Ознакомление", СтруктураДопПараметров);
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУровень(ТекЭлементы, ТекМаршрутПлоский, ТекИдГруппы, ТекУровень, ТекИндекс, ТипТЧ, СтруктураДопПараметров)
	
	Для каждого ТекСтрока Из ТекМаршрутПлоский Цикл
		Если ТекМаршрутПлоский.Индекс(ТекСтрока) < ТекИндекс Тогда
			Продолжить;		
		КонецЕсли;
		Если НЕ ТекИдГруппы = ТекСтрока.ИДГруппы И ТекСтрока.Уровень >= ТекУровень И ТекСтрока.Уровень > 1 Тогда
			ТекСтрокаКоллекц = ТекЭлементы.Добавить();
			ТекСтрокаКоллекц.Пользователь = ТекСтрока.ТипГруппы;
			ТекСтрокаКоллекц.ИДГруппы = ТекСтрока.ИДГруппы;
			ТекСтрокаКоллекц.Уровень = ТекСтрока.Уровень;
			ЗаполнитьУровень(ТекСтрокаКоллекц.ПолучитьЭлементы(), ТекМаршрутПлоский, ТекСтрока.ИДГруппы,  ТекСтрока.Уровень, ТекМаршрутПлоский.Индекс(ТекСтрока), ТипТЧ, СтруктураДопПараметров);
			Прервать;
		ИначеЕсли ТекСтрока.Уровень < ТекУровень И НЕ ТекСтрокаКоллекц = Неопределено Тогда
			ТекРод = ТекСтрокаКоллекц.ПолучитьРодителя();
			Для ТТ = 1 По ТекУровень - ТекСтрока.Уровень + 1 Цикл
				Если НЕ ТекРод.Пользователь = "Согласование" И НЕ ТекРод.Пользователь = "Исполнение" И НЕ ТекРод.Пользователь = "Ознакомление" Тогда
					ТекРод = ТекРод.ПолучитьРодителя();
				КонецЕсли;
			КонецЦикла;
			Если НЕ ТекРод = Неопределено Тогда
				ЗаполнитьУровень(ТекРод.ПолучитьЭлементы(), ТекМаршрутПлоский, ТекРод.ИДГруппы,  ТекРод.Уровень, ТекМаршрутПлоский.Индекс(ТекСтрока), ТипТЧ, СтруктураДопПараметров);
			КонецЕсли;
			Прервать;
		Иначе
			ТекСтрокаКоллекц = ТекЭлементы.Добавить();
			ЗаполнитьЗначенияСвойств(ТекСтрокаКоллекц, ТекСтрока);
			ТекСтрокаКоллекц.ИДГруппы = ТекСтрокаКоллекц.ПолучитьРодителя().ИДГруппы;
			
			Если ТипТЧ = "Согласование" Тогда
				ПредставлениеПользователя = ТекСтрока.СубъектСогласования;
			ИначеЕсли ТипТЧ = "Исполнение" Тогда	
				ПредставлениеПользователя = ТекСтрока.Исполнитель;
				Если ТекСтрокаКоллекц.Свойство("Согласовано") Тогда
					ТекСтрокаКоллекц.Согласовано = ТекСтрока.Исполнено;
				КонецЕсли;
				Если ТекСтрокаКоллекц.Свойство("Пройден") Тогда
					ТекСтрокаКоллекц.Пройден = ТекСтрока.Пройдено;
				КонецЕсли;
			Иначе
				ПредставлениеПользователя = ТекСтрока.Пользователь;
				Если ТекСтрокаКоллекц.Свойство("Пройден") Тогда
					ТекСтрокаКоллекц.Пройден = ТекСтрока.Оповещен;
				КонецЕсли;
			КонецЕсли;
			ТекСтрокаКоллекц.Пользователь = ПредставлениеПользователя;
			//заменяем на пользователя
			Если НЕ СтруктураДопПараметров = Неопределено И СтруктураДопПараметров.Свойство("Предприятие") Тогда
				Если ТипЗнч(ПредставлениеПользователя) = Тип("ПеречислениеСсылка.ОсновныеДолжностиПредприятия") Тогда
					ТекСтрокаКоллекц.Пользователь = БПСервер.ПолучитьСотрудникаПоОсновнойДолжности(СтруктураДопПараметров.Предприятие, ПредставлениеПользователя, Неопределено);
				ИначеЕсли ТипЗнч(ПредставлениеПользователя) = Тип("СправочникСсылка.Должности") Тогда
					ТекСтрокаКоллекц.Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("Должность", ПредставлениеПользователя);	
				ИначеЕсли ТипЗнч(ПредставлениеПользователя) = Тип("СправочникСсылка.Пользователи") Тогда
					ТекСтрокаКоллекц.Пользователь = ПредставлениеПользователя; 	
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;	
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппировкиДерева(Элементы, МаршрутДерево) Экспорт
	
	Коллекция = МаршрутДерево.ПолучитьЭлементы();
	Для каждого ТекЭлемент Из Коллекция Цикл
		Элементы.ТаблицаФормы123.Развернуть(ТекЭлемент.ПолучитьИдентификатор(), Истина);	
	КонецЦикла;
	
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьВопросыПоДокументу(Элементы, ЭлементРодитель, Команды, Документ, КоличествоПереписки = 0) Экспорт
	
	Если НЕ Элементы.Найти("ВопросыПоДокументуСсылка") = Неопределено Тогда
		Элементы.Удалить(Элементы["ВопросыПоДокументуСсылка"]);
	КонецЕсли;
	
	КоличВопросов = 0;
	БПСервер.ВывестиВопросыПоДокументу(Неопределено, Документ, Истина, КоличВопросов);
	
	Если НЕ КоличВопросов Тогда
		Возврат;
	КонецЕсли;
	КоличествоПереписки = КоличествоПереписки + КоличВопросов;
	
	Если Команды.Найти("ВопросыПоДокументу") = Неопределено Тогда
		НоваяКоманда = Команды.Добавить("ВопросыПоДокументу");
		НоваяКоманда.Действие  = "ВопросыПриНажатии";
	КонецЕсли;
	НовыйЭлемент = Элементы.Добавить("ВопросыПоДокументуСсылка", Тип("КнопкаФормы"), ЭлементРодитель);
	НовыйЭлемент.Заголовок = "Вопросы по документу" + ?(КоличВопросов, " (" + Строка(КоличВопросов) + ")", "");
	НовыйЭлемент.ИмяКоманды = "ВопросыПоДокументу";
	//НовыйЭлемент.ВысотаЗаголовка = 2;
	//НовыйЭлемент.Ширина = 10;
	//НовыйЭлемент.Высота = 2;	
	НовыйЭлемент.Вид = ВидКнопкиФормы.Гиперссылка;
КонецПроцедуры

&НаСервере
Процедура ОбсуждениеПоДокументу(Элементы, ЭлементРодитель, Команды, Документ, КоличествоПереписки = 0) Экспорт
	
	Если НЕ Элементы.Найти("ОбсуждениеПоДокументуСсылка") = Неопределено Тогда
		Элементы.Удалить(Элементы["ОбсуждениеПоДокументуСсылка"]);
	КонецЕсли;
	
	КоличОбсуждений = 0;
	БПСервер.ВывестиОбсужденияПоДокументу(Неопределено, Документ, Истина, КоличОбсуждений);
	
	Если НЕ КоличОбсуждений Тогда
		Возврат;
	КонецЕсли;
	КоличествоПереписки = КоличествоПереписки + КоличОбсуждений; 
	
	Если Команды.Найти("ОбсуждениеПоДокументу") = Неопределено Тогда
		НоваяКоманда = Команды.Добавить("ОбсуждениеПоДокументу");
		НоваяКоманда.Действие  = "ОбсуждениеПриНажатии";
	КонецЕсли;
	НовыйЭлемент = Элементы.Добавить("ОбсуждениеПоДокументуСсылка", Тип("КнопкаФормы"), ЭлементРодитель);
	НовыйЭлемент.Заголовок = "Обсуждение документа" + ?(КоличОбсуждений, " (" + Строка(КоличОбсуждений) + ")", "");
	НовыйЭлемент.ИмяКоманды = "ОбсуждениеПоДокументу";
	//НовыйЭлемент.ВысотаЗаголовка = 2;
	//НовыйЭлемент.Ширина = 10;
	//НовыйЭлемент.Высота = 2;	
	НовыйЭлемент.Вид = ВидКнопкиФормы.Гиперссылка;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГруппуКнопокПечать(Элементы, Команды, СписокКоманд, Задача) Экспорт
	СписокКоманд.Очистить();
	//Метаданные.Документы.Д_ЗаявкаНаОплату.Команды.ПечатьБезНал.ИзменяетДанные
	
	Если НЕ Элементы.Найти("КомандаПечати") = Неопределено Тогда
		Элементы.Удалить(Элементы["КомандаПечати"]);
	КонецЕсли;
	
	МассивКоманд = Новый Массив;
	
	Если Не ЗначениеЗаполнено(Задача.Заявка) Тогда
		Возврат; //прерываем заполнение
	КонецЕсли;
	
	СписокКоманды = Задача.Заявка.Метаданные().Команды;
	Для каждого ТекКоманда Из СписокКоманды Цикл
		Если ТекКоманда.ТипПараметраКоманды.СодержитТип(ТипЗнч(Задача.Заявка)) И Найти(Строка(ТекКоманда.Группа), "Печать") И ПравоДоступа("Просмотр", ТекКоманда) Тогда
			МассивКоманд.Добавить(ТекКоманда);		
		КонецЕсли;
	КонецЦикла;
	
	СписокКоманды = Метаданные.Документы.Д_ЗаявкаНаОплату.Команды;
	Для каждого ТекКоманда Из СписокКоманды Цикл
		Если ТекКоманда.ТипПараметраКоманды.СодержитТип(ТипЗнч(Задача.Заявка)) И Найти(Строка(ТекКоманда.Группа), "Печать") И ПравоДоступа("Просмотр", ТекКоманда) И МассивКоманд.Найти(ТекКоманда) = Неопределено Тогда
			МассивКоманд.Добавить(ТекКоманда);		
		КонецЕсли;
	КонецЦикла;

	СписокКоманды = Метаданные.Документы.Д_СлужебнаяЗаписка.Команды;
	Для каждого ТекКоманда Из СписокКоманды Цикл
		Если ТекКоманда.ТипПараметраКоманды.СодержитТип(ТипЗнч(Задача.Заявка)) И Найти(Строка(ТекКоманда.Группа), "Печать") И ПравоДоступа("Просмотр", ТекКоманда) И МассивКоманд.Найти(ТекКоманда) = Неопределено Тогда
			МассивКоманд.Добавить(ТекКоманда);		
		КонецЕсли;
	КонецЦикла;
	
	НоваяКнопка = Элементы.Добавить("КомандаПечати", Тип("ГруппаФормы"), Элементы.Печать);
	НоваяКнопка.Заголовок = "Команды документа";
	
	
	Индекс = 0;
	Для каждого ТекСтрока Из МассивКоманд Цикл
		Если Команды.Найти(ТекСтрока.Имя + Строка(Индекс)) = Неопределено Тогда
			НоваяКоманда = Команды.Добавить(ТекСтрока.Имя + Строка(Индекс));
			НоваяКоманда.Действие  = "ИндивидуальнаяКоманда";
		КонецЕсли;
		НоваяКнопка = Элементы.Добавить(ТекСтрока.Имя + Строка(Индекс), Тип("КнопкаФормы"),Элементы["КомандаПечати"]);
		НоваяКнопка.Заголовок = ?(ЗначениеЗаполнено(ТекСтрока.Синоним), ТекСтрока.Синоним, ТекСтрока.Имя);
		НоваяКнопка.ИмяКоманды = ТекСтрока.Имя + Строка(Индекс);
		СписокКоманд.Добавить(ТекСтрока.ПолноеИмя());
		Индекс = Индекс + 1;
	КонецЦикла; 
	
КонецПроцедуры

